require "time_cursor"

class TimeScheduler

  class Schedule
    NICE_TIME  =  0.001

    class << self
      def active?
        ! @@pause
      end

      def suspend
        @@pause  =  true
      end

      def resume
        @@pause  =  false
      end
    end

    def initialize
      @schedule_thread  =  nil
      @schedule_mutex  =  ::Mutex.new
      @signal_queue  =  ::Queue.new

      @@pause  =  false
      @@EventQueue  ||=  TimeScheduler::EventQueue.new
    end

    def cancel
      @signal_queue.push( nil )
    end

    def setup( **option, &block )
      @option  =  option
      @action  =  option[:action]  ||  block  ||  @action

      opt  =  {}
      @option.each do |k, v|
        if  [:at, :cron, :year, :month, :day, :wday, :hour, :min, :sec, :msec].include?(k)
          opt[k]  =  v
        end
      end
      @time_cursor  =  TimeCursor.new( **opt )
      @nice_time  =  option[:nice].to_i  *  NICE_TIME
      time  =  Time.now
      @ident  =  time.to_i * 1000000 + time.usec
    end

    def wait_each( **option, &block )
      setup( **option, &block )

      @schedule_thread  =  ::Thread.start do
        while  true
          target_time  =  @time_cursor.next
          if  target_time.nil?
            @signal_queue.clear
            break
          end

          @@EventQueue.reserve( target_time + @nice_time, @signal_queue, @ident )

          while  true
            time, ident  =  * @signal_queue.pop
            break    if  time.nil?  ||  ident == @ident
          end

          if  time.nil?
            @signal_queue.clear
            break
          end

          next    if  @@pause

          ::Thread.start( time ) do |t|
            @schedule_mutex.synchronize do
              @action.call( t )
            end
          end
        end
        nil
      end
      nil
    end

    def wait_once( **option )
      setup( **option )

      @schedule_thread  =  ::Thread.start do
        target_time  =  @time_cursor.next
        if  target_time.nil?
          @signal_queue.clear
          break
        end

        @@EventQueue.reserve( target_time + @nice_time, @signal_queue, @ident )

        while  true
          time, ident  =  * @signal_queue.pop
          break    if  time.nil?  ||  ident  == @ident
        end

        if  time.nil?
          @signal_queue.clear
        end
        time
      end

      @schedule_thread.join
      time  =  @schedule_thread.value
      time
    end

    def wait_reset( **option, &block )
      if @action
        setup( **option, &block )
      else
        option[:action]  =  nil
        setup( **option )
      end

      time_next  =  @time_cursor.next
      @@EventQueue.reserve( time_next + @nice_time, @signal_queue, @ident )    if  time_next
    end
  end

  class Scheduler
    def schedules
      @schedules  ||=  {}
    end

    def reserved?( topic )
      schedules.has_key?( topic )
    end

    def wait_reset( topic, **option, &block )
      if ( schedule  =  schedules[topic] )
        schedule.wait_reset( **option, &block )
        topic
      end
    end

    def wait_each( topic, **option, &block )
      schedule  =  TimeScheduler::Schedule.new
      schedules[topic]  =  schedule
      schedule.wait_each( **option, &block )
      topic
    end

    def wait_once( topic, **option )
      schedule  =  TimeScheduler::Schedule.new
      schedules[topic]  =  schedule
      schedule.wait_once( **option )
    ensure
      schedules.delete( topic )
    end

    def topics
      schedules.keys.dup
    end

    def cancel( topic )
      if ( schedule  =  schedules[topic] )
        schedule.cancel
      end
    rescue => e
      puts  e.backtrace
    ensure
      schedules.delete( topic )
    end

    def join
      while  schedules.size > 0
        topic  =  schedules.keys.first
        schedule  =  schedules[topic]
        schedule.join
      end
    end
  end

  class Counter
    def initialize
      @count  =  0
      @mutex  =  Mutex.new
    end

    def incr
      @mutex.synchronize do
        @count  +=  1
      end
    end

    def decr
      @mutex.synchronize do
        @count  -=  1    if  @count > 0
        @count
      end
    end

    def reset
      @mutex.synchronize do
        @count  =  0
      end
    end
  end

  def initialize
    @first_counter  =  Hash.new{|h,k| h[k] = Counter.new }
    @last_counter   =  Hash.new{|h,k| h[k] = Counter.new }
  end

  def scheduler
    @@Scheduler  ||=  TimeScheduler::Scheduler.new
  end

  def wait( topic = Time.now.iso8601(6), **option, &block )
    raise  TimeScheduler::Error, "option missing."    if  option.empty?

    if scheduler.reserved?( topic )
      scheduler.wait_reset( topic, **option, &block )
    else
      if option[:action].nil?  &&  block.nil?
        scheduler.wait_once( topic, **option )
      else
        scheduler.wait_each( topic, **option, &block )
      end
    end
  end

  def topics
    scheduler.topics
  end

  def cancel( *topics )
    topics.each do |topic|
      scheduler.cancel( topic )
    end
  end

  def active?
    TimeScheduler::Schedule.active?
  end

  def suspend
    TimeScheduler::Schedule.suspend
  end

  def resume
    TimeScheduler::Schedule.resume
  end

  def first_only( ident = nil, timeout: 1, &block )
    key  =  [ caller[0], ident.to_s ].join(":")
    count  =  @first_counter[key].incr
    block.call    if count == 1
    ::Thread.start( key ) do |k|
      ::Kernel.sleep  timeout
      @first_counter[k].decr
    end
  end

  def last_only( ident = nil, timeout: 1, &block )
    key  =  [ caller[0], ident.to_s ].join(":")
    @last_counter[key].incr
    ::Thread.start( key ) do |k|
      ::Kernel.sleep  timeout
      count  =  @last_counter[k].decr
      block.call    if count == 0
    end
  end

end

