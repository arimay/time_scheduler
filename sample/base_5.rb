require "time_scheduler"

Scheduler  =  TimeScheduler.new

class Sample
  def initialize
    Scheduler.wait( :cyclic, sec: "*" ) do |time|
      p time.iso8601(3)
    end
  end

  def stop
    p :stop
    Scheduler.cancel( :cyclic )
  end
end

sample  =  Sample.new

sleep  3

sample.stop

sleep  3

