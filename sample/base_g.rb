require "time_scheduler"

Scheduler  =  TimeScheduler.new

cyclic = {
  sec: "*"
}
quit = {
  sec: "*/20"
}

Scheduler.wait( **cyclic ) do |time|
  p [time.iso8601(3), :cyclic]
end

Scheduler.wait( **quit ) do |time|
  p [time.iso8601(3), :quit]
  exit
end

while true
  sleep  3
  time  =  Time.now
  p [time.iso8601(3), :toggle]

  bool  =  Scheduler.active?
  p [:active?, bool]
  if  bool
    p :suspend
    Scheduler.suspend
  else
    p :resume
    Scheduler.resume
  end
end

