require "time_scheduler"

Scheduler  =  TimeScheduler.new

Scheduler.wait( :a, sec: '*', nice: 1 ) do |time|
  p [time.iso8601(3), :every]
end

Scheduler.wait( :b, sec: '*/5', nice: 2 ) do |time|
  p [time.iso8601(3), :once]
  Scheduler.cancel( :b )
end

Scheduler.wait( :c, sec: '*/10', nice: 3 ) do |time|
  p [time.iso8601(3), :quit]
  exit
end

p [Time.now.iso8601(3), :ready]
sleep

