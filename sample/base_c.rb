require "time_scheduler"

Scheduler  =  TimeScheduler.new

Scheduler.wait( sec: '*/2', nice: 1 ) do |time|
  p [time.iso8601(3), :every, :A]
end

Scheduler.wait( sec: '*/3', nice: 2 ) do |time|
  p [time.iso8601(3), :every, :B]
end

Scheduler.wait( sec: '*/4', nice: 3 ) do |time|
  p [time.iso8601(3), :every, :C]
end

Scheduler.wait( at: Time.now + 30, nice: 4 ) do |time|
  p [time.iso8601(3), :quit]
  exit
end

p [Time.now.iso8601(3), :ready]
sleep

