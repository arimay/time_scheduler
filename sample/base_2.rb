
require "time_scheduler"

Scheduler  =  TimeScheduler.new

goal  =  Time.now + 3
Scheduler.wait( :foo, sec: "*" ) do |time|
  p Time.now.iso8601(3)
  Scheduler.cancel( :foo )    if time > goal
end
sleep  5

