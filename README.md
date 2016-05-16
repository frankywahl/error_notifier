# ErrorNotifier

A tool for managing multiple error handlers. This decouples the error handling from the tools that is used to do so.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'error_notifier'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install error_notifier

## Usage

This tools enables you to register multiple error handlers, and report to them appropriately.

It allows for decoupling between the tool used to notify errors, and where those errors are being notified.

It a single place to manage all of your error handling tools.

Example:

Registering a new tool:

```ruby
# config/initializer.rb

ErrorNotifier.add_notifier(:my_notifier) do |exception, options|
  # Do something with the exception
  # Optional parameters can be passed in the options
end

# Example with NewRelic:
ErrorNotifier.add_notifier(:newrelic) do |exception, options|
  NewRelic::Agent.notice_error(exception)
end

# Example with Honeybader
ErrorNotifier.add_notifier(:honeybadger) do |exception, options|
  Honeybadger.notify_or_ignore(exception)
end
```

Then, in the actual code

```ruby
begin
  # Do something that may raise an exception
rescue => e
  ErrorNotifier.notify(e)
end
```

Now suppose we wanted to add options, for specific handling of some tools, we could have the following in our initializer

```ruby
# in an initializer
ErrorNotifier.add_notifier(:my_notifier) do |exception, options|
  MyNotifier.notify(exception, options[:my_notifier])
end

# in code
begin
  #...
rescue => e
  options = { my_notifier: 'Some Cool Hash' }
  ErrorNotifier.notify(e, options)
end
```

Now, the addition/removal of an existing tool can be done independently (loosely coupled) to the tool being used, while the granularity of error logging that each tool provides you with can be preserved.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/error_notifier.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
