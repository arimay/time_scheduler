require "time_scheduler"

Scheduler  =  TimeScheduler.new

check = {
  sec: "*"
}

goal  =  Time.now + 3
Scheduler.wait( **check ) do |time|
  p [time.iso8601(3), :cyclic]
  if time > goal
    p [time.iso8601(3), :quit]
    exit
  end
end

p [Time.now.iso8601(3), :ready]
sleep

