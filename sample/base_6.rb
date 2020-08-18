require "time_scheduler"

Scheduler  =  TimeScheduler.new

Signal.trap( :INT ) do
  exit
end

Scheduler.wait sec: "*/5" do |time|
  p [Time.now.iso8601(3), :sec5]
end

Scheduler.wait cron: "* * * * *" do |time|
  p [Time.now.iso8601(3), :cron]
end

Scheduler.wait at: (Time.now + 60) do |time|
  p [Time.now.iso8601(3), :quit]
  exit
end

p [Time.now.iso8601(3), :ready]
sleep

