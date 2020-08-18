require "time_scheduler"

Scheduler  =  TimeScheduler.new

cyclic = {
  sec: '*'
}

goal  =  Time.now + 60

Scheduler.wait( :tick, **cyclic ) do |time|
  case  time.sec
  when  0, 20, 40
    p [time.iso8601(3), :tick_1, '*']
    Scheduler.wait( :tick, sec: '*' )
  when  10, 30, 50
    p [time.iso8601(3), :tick_2, '*/2']
    Scheduler.wait( :tick, sec: '*/2' )
  else
    p [time.iso8601(3), :tick]
  end

  if  time > goal
    p [time.iso8601(3), :quit]
    exit
  end
end

p [Time.now.iso8601(3), :ready]
sleep

