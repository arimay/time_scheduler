require "time_scheduler"

Scheduler  =  TimeScheduler.new

cyclic1 = {
  msec: "*/100"
}
cyclic2 = {
  sec: "*/2"
}

Scheduler.wait( **cyclic1 ) do |time|
  p [time.iso8601(3), :cyclic1]
end

goal  =  Time.now + 5
Scheduler.wait( **cyclic2 ) do |time|
  p [time.iso8601(3), :cyclic2]
  if time > goal
    p [time.iso8601(3), :quit]
    exit
  end
end

p [Time.now.iso8601(3), :ready]
sleep

