# DockerizeRails

[![GitHub tag](https://img.shields.io/github/tag/eendroroy/dockerize_rails.svg)](https://github.com/eendroroy/dockerize_rails)
[![Gem Version](https://badge.fury.io/rb/dockerize_rails.svg)](https://rubygems.org/gems/dockerize_rails)
[![Downloads](https://img.shields.io/gem/dt/dockerize_rails.svg)](https://rubygems.org/gems/dockerize_rails)
[![Build Status](https://travis-ci.org/eendroroy/dockerize_rails.svg?branch=master)](https://travis-ci.org/eendroroy/dockerize_rails)
[![Code Climate](https://codeclimate.com/github/eendroroy/dockerize_rails/badges/gpa.svg)](https://codeclimate.com/github/eendroroy/dockerize_rails)
[![Contributors](https://img.shields.io/github/contributors/eendroroy/dockerize_rails.svg)](CONTRIBUTORS.md)

## Installation

Add this line to your rails application's Gemfile:

```ruby
gem 'dockerize_rails'
```

And then execute:
```bash
$ bundle
```

## Usage

```bash
$ bundle exec dock help
$ bundle exec dock configure
$ bundle exec dock configure --skip-desc
$ bundle exec dock dockerize
$ bundle exec dock dockerize --config-test
$ bundle exec dock undockerize
$ bundle exec dock undockerize --purge
$ bundle exec dock docker_info
```

## Demo

[![asciicast](https://asciinema.org/a/121552.png)](https://asciinema.org/a/121552)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/eendroroy/dockerize_rails. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bhttps%3A%2F%2Fgithub.com%2Feendroroy%2Fdockerize_rails.svg?type=large)](https://app.fossa.io/projects/git%2Bhttps%3A%2F%2Fgithub.com%2Feendroroy%2Fdockerize_rails?ref=badge_large)

