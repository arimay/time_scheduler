require "time_scheduler"

Scheduler  =  TimeScheduler.new

(0..4).each do
  p [Time.now.iso8601(3), :cycle]
  Scheduler.first_only( timeout: 10 ) do
    p [Time.now.iso8601(3), :first]
  end
  Scheduler.last_only( timeout: 10 ) do
    p [Time.now.iso8601(3), :last]
  end
  sleep 1
end

Scheduler.wait( at: Time.now + 10 )
p [Time.now.iso8601(3), :quit]
