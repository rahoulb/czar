# Czar

Czar is a framework for building applications around the Command
pattern.  

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


## Contributing

1. Fork it ( http://github.com/<my-github-username>/czar/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
