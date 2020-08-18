require "time_scheduler"

Scheduler  =  TimeScheduler.new

count  =  0
Scheduler.wait( sec: '*' ) do |time|
  count  +=  1
  p [time.iso8601(3), :cyclic, count]
  if count >= 10
    p [time.iso8601(3), :quit]
    exit
  end
end

p [Time.now.iso8601(3), :ready]
sleep

