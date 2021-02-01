require "time_scheduler"

Scheduler  =  TimeScheduler.new

class Sample
  Scheduler.wait( sec: "*" ) do |time|
    p time.iso8601(3)
  end
end

Sample.new

sleep  5

