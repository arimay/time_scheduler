
class TimeScheduler

  class Error < StandardError; end

  class EventItem
    include ::Comparable

    attr_reader :time, :queue, :ident

    def initialize( time, queue, ident )
      @time  =  time
      @queue  =  queue
      @ident  =  ident
    end

    def <=>( other )
      return  nil    unless other.is_a?( EventItem )
      self.time <=> other.time
    end
  end

  class EventQueue

    REFRESH_TIME  =  3600.0

    def initialize
      @event_mutex  =  ::Mutex.new
      @event_queue  =  ::Queue.new
      @event_set  =  OrderSet.new
      run
    end

    def reserve( time, queue, ident )
      @event_mutex.synchronize do
        @event_set.add( EventItem.new( time, queue, ident ) )
        wait_time  =  [time - Time.now, REFRESH_TIME + rand * 2 - 1].min
        if  wait_time <= 0
          @event_queue.push( 1 )
        else
          Thread.start do
            ::Kernel.sleep( wait_time )
            @event_queue.push( 1 )
          end
        end
      end
    end

    def refresh( time )
      wait_time  =  [time - Time.now, REFRESH_TIME + rand * 2 - 1].min
      Thread.start do
        ::Kernel.sleep( wait_time )
        @event_queue.push( 1 )
      end
    end

    def run
      Thread.start do
        begin
          while  true
            @event_queue.pop
            @event_mutex.synchronize do
              event_item  =  @event_set.first
              now  =  Time.now
              if  event_item.time <= now
                @event_set.delete( event_item )
                event_item.queue.push( [now, event_item.ident] )
              else
                refresh( event_item.time )
              end
            end
          end
        rescue => e
          raise  ::TimeScheduler::Error, "#{__FILE__}: #{e.message}"
        end
      end
    end

  end

end

