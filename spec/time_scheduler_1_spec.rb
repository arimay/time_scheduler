
RSpec.describe TimeScheduler do

  it 'time = scheduler.wait(sec:"*")' do
    scheduler  =  TimeScheduler.new
    goal  =  Time.now + 3
    while ( time  =  scheduler.wait( sec: "*" ) )
      break    if time > goal
    end
    result  =  ( ( time.to_i - goal.to_i ).abs <= 1 )
    expect( result ).to be true
  end

  it 'scheduler.wait( :foo, sec: "*" ) do' do
    scheduler  =  TimeScheduler.new
    queue  =  Queue.new
    goal  =  Time.now + 3
    scheduler.wait( :foo, sec: "*" ) do |time|
      if time > goal
        scheduler.cancel( :foo )
        queue.push  true
      end
    end
    result  =  queue.pop
    expect( result ).to be true
  end

  it 'scheduler.wait( sec: "*" ) do' do
    scheduler  =  TimeScheduler.new
    queue  =  Queue.new
    goal  =  Time.now + 3
    scheduler.wait( sec: "*" ) do |time|
      if time > goal
        queue.push  true
      end
    end
    result  =  queue.pop
    expect( result ).to be true
  end

  it 'scheduler.first_only( timeout: 10 ) do' do
    scheduler  =  TimeScheduler.new
    items  =  []
    (0..4).each do
      scheduler.first_only( timeout: 10 ) do
        items  <<  :first
      end
      sleep 1
      items  <<  0
    end
    scheduler.wait( at: Time.now + 10 )
    expect( items ).to eq [:first, 0, 0, 0, 0, 0]
  end

  it 'scheduler.last_only( timeout: 10 ) do' do
    scheduler  =  TimeScheduler.new
    items  =  []
    (0..4).each do
      scheduler.last_only( timeout: 10 ) do
        items  <<  :last
      end
      sleep 1
      items  <<  0
    end
    scheduler.wait( at: Time.now + 10 )
    expect( items ).to eq [0, 0, 0, 0, 0, :last]
  end

end

