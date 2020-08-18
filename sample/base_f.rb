require "time_scheduler"

Scheduler  =  TimeScheduler.new

Scheduler.wait( :tick, msec: '*/10' ) do |time|
  p [time.iso8601(3), :tick]
end

Scheduler.wait( :stop, at: Time.now + 1 ) do |time|
  p [time.iso8601(3), :stop]
  Scheduler.cancel( :tick )
end

Scheduler.wait( :quit, at: Time.now + 2 ) do |time|
  p [time.iso8601(3), :quit]
  exit
end

p [Time.now.iso8601(3), :ready]
sleep

