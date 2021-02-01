require "time_scheduler"

Scheduler  =  TimeScheduler.new

Scheduler.wait( sec: "*" ) do |time|
  p time.iso8601(3)
end

sleep  5

