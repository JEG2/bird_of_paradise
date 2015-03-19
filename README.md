# BirdOfParadise

This Twitter client uses [the Rurses library](https://github.com/JEG2/rurses) to build a moderate sized curses application that uses many typical input and output features.  This is meant to serve as an example for how to build your own curses applications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bird_of_paradise'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bird_of_paradise

## Usage

You can launch the client with:

    $ bin/bop

Use the `tab` key to move between columns, `j` and `k` to scroll tweets, and `q` to quit.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/bird_of_paradise/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
