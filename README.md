# Czar

Czar is a framework for building applications around the Command
pattern.  However, it is intended that these commands will stop at
various points during their lifetime, then resume again a bit later.
Maybe in response to incoming web-requests, because there's a
background timer in action, or simply because we are waiting on an
external resource.

Everything your application does is a Command of some kind; those
commands may be simple actions, sequences of actions, sequences with
decisions within them or series that trigger other commands.  

The advantage of using commands within, for example, a Rails application
is that you can then make your database model classes *passive* - that
is they become purely data - and the interesting stuff is all handled by
commands.  No more fat models with callbacks all over the place.  

Plus using commands makes it easy to ensure that authorisation is done
correctly (as each command is well-defined) and makes it trivial to add
in logging and so on.  

Czar can allow commands to be persisted (with a in-memory and a Redis adapter for now).

## Installation

Add this line to your application's Gemfile:

    gem 'czar'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install czar

## Usage

The Command module represents an implementation of the Command pattern
where each Command has an internal state machine and can optionally spawn child commands.
At its simplest, a Command will be executed, moving it from "start" state to "complete" state. 
For example:
```
class SimpleCommand
  include Czar::Command

  def start
   result = some_complex_calculation
   mark_as :complete, result: result
  end

  def some_complex_calculation
   return :whatever
  end
end
```

To use this, simply call SimpleCommand.new.execute - the command will perform #some_complex_calculation and then be marked as :complete - we can then find out what happend by calling the #result method.

By itself, this is pretty boring.  However, as we've got a simple state machine in there, we can do more interesting stuff; especially when a command is persistent.

For example:
```
class DrivesACar
  include Czar::Command

  def start
    mark_as :moving
  end

  def moving
    move_forward
    if has_reached_destination?
      mark_as :complete
    elsif traffic_light.colour == :green
      mark_as :moving
    else 
      mark_as :stopped
    end
  end

  def move_forward
    :vroom
  end

  def has_reached_destination?
    # code goes here
  end
end
```

In this case, we instantiate a DrivesACar command and store it somewhere.  Every now and then (in response to a timer, a cron job or some other trigger) we call execute, which looks at the command's internal state and chooses if it is moving or stopped.  Eventually, when we have reached our destination, the command is marked as complete. Also note, that as we do nothing when stopped, there's no need to define a stopped method.  

Commands can also trigger child commands, and are notified when the child completes.

For example: 

```
class CourierDeliversAParcel < Struct.new(:pickup_location, :dropoff_location)
  include Czar::Command

  def start
    perform CollectsParcel.new(pickup_location)
    mark_as :waiting_for_pickup
  end

  def child_task_completed task
    if self.state == :waiting_for_pickup
      perform DeliversParcel.new(dropoff_location)
      mark_as :waiting_for_dropoff
    elsif self.state == :waiting_for_dropoff
      mark_as :complete
    end
  end
end
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/czar/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
