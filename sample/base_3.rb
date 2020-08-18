require "time_scheduler"

Scheduler  =  TimeScheduler.new

Scheduler.wait( sec: "*" ) do |time|
  p Time.now.iso8601(3)
end

sleep  5

