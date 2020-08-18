require "time_scheduler"

Scheduler  =  TimeScheduler.new

cyclic = {
  sec: '*',
}
onetime = {
  sec: '*/5',
}

count  =  0
Scheduler.wait( **cyclic ) do |time|
  p [time.iso8601(3), :cyclic]
  count  +=  1
  if count >= 15
    p [time.iso8601(3), :quit]
    exit
  end
end

Scheduler.wait( :onetime, **onetime ) do |time|
  p [time.iso8601(3), :onetime]
  Scheduler.cancel( :onetime )
end

p [Time.now.iso8601(3), :ready]
sleep

