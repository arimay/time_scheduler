
require "time_scheduler"

Scheduler  =  TimeScheduler.new

goal  =  Time.now + 3
while  time  =  Scheduler.wait( sec: "*" )
  p Time.now.iso8601(3)
  break    if time > goal
end

