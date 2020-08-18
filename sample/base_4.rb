require "time_scheduler"

Scheduler  =  TimeScheduler.new

class Sample
  Scheduler.wait( sec: "*" ) do |time|
    p Time.now.iso8601(3)
  end
end

sample  =  Sample.new

sleep  5

