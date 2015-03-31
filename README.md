# NewRelic::Shoes

`newrelic-shoes` brings New Relic's method tracing to Shoes for local
development performance testing.

## Installation

```ruby gem 'newrelic-shoes' ```

You may find it necessary to `bundle exec bin/shoes` to get things loading
right.

## Usage

Once the gem is installed in your Shoes application, press Ctrl+Alt+N to start
New Relic tracing. At exit the Shoes custom metrics are emitted to STDOUT.

Future plans include an embedded developer mode and transactions for layout and
painting, but for now the targetted metrics are useful when tuningk specific
methods that aren't easily isolated to a benchmark (i.e. painting).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release` to create a git tag for the version, push git
commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/jasonrclark/newrelic-shoes/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
