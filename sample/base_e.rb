require "time_scheduler"

Scheduler  =  TimeScheduler.new

Scheduler.wait( :A, sec: '*/5', nice: 1 ) do |time|
  p [time.iso8601(3), :every, :A]
end

Scheduler.wait( :B, sec: '*/10', nice: 2 ) do |time|
  p [time.iso8601(3), :every, :B]
end

Scheduler.wait( :C, sec: 30, nice: 3 ) do |time|
  p [time.iso8601(3), :once, :C]
  Scheduler.cancel( :A )
end

Scheduler.wait( :D, sec: 0, nice: 4 ) do |time|
  p [time.iso8601(3), :once, :D]
  exit
end

p [Time.now.iso8601(3), :ready]
sleep

