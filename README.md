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
$ bundle install
```

## Usage

First create the configuration file `.dockerize.yml` for the gem itself.
Run: `bundle exec dock configure` to generate the template.
Use `--tiny` option to skip the description of configuration fields: `bundle exec dock configure --tiny`.

To create the docker config files (Dockerfile, provisions, docker-compose.yml etc.) run: `bundle exec dock dockerize`.
To create docker environment for running tests use `--test-env` option: `bundle exec dock dockerize --test-env`.

Use `docker-compose` to run application in docker: `docker-compose build && docker-compose up -d`.

If you see **migration error** in browser run the following commands:

```bash
$ docker-compose down        # stop and destroy all running containers
$ docker-compose up -d mysql # if application uses postgresql database use 'postgresql' instead of 'mysql'
$ sleep 30                   # wait 30 seconds to let the database container start properly
$ docker-compose up -d rails # now start the rails container
```

To remove docker configurations: `bundle exec dock undockerize`. Use `--purge` option to remove `.dockerize.yml` file: `bundle exec dock undockerize --purge`

All available commands:
```bash
$ bundle exec dock help
$ bundle exec dock configure [ --tiny ]
$ bundle exec dock dockerize [ --test-env ]
$ bundle exec dock undockerize [ --purge ]
$ bundle exec dock docker_info
$ bundle exec dock docker_pull
$ bundle exec dock docker_build [ --log | --rebuild | --rebuild --force ]
$ bundle exec dock docker_start
$ bundle exec dock docker_stop [ --delete ]
$ bundle exec dock docker_delete [ --force ]
```

Help message:
```
Usage: dock <command>
   or: bundle exec dock <command>

   commands:

        configure, c, rc, cr           - Generates '.dockerize.yml'
          [--tiny]        -- Generates shorter config file, skipping all descriptions

        dockerize, dc, d               - Generates docker config files
          [--test-env]    -- Generates configurations to run tests.

        undockerize, ud, du, u, dd     - Removes docker configurations
          [--purge]       -- Also removes .dockerize.yml

        docker_info, info              - Shows Docker information
        docker_pull, pull              - Pulls base Docker images (ruby, mysql/postgres)
        docker_build, build            - Builds Docker images
          [--log]         -- Displays/Streams build log
          [--rebuild]     -- Deletes images if exists and rebuilds
          [--force]       -- Force Image deletion. Works only with --rebuild option

        docker_start, start            - Run/Starts Docker containers
        docker_stop, stop              - Stops Docker containers
          [--delete]      -- Also deletes the containers

        docker_delete, delete          - Deletes Docker containers
          [--force]       -- Force Container deletion.

        help, h                        - Prints this message
```

## Demonstration

[![asciicast](https://asciinema.org/a/121552.png)](https://asciinema.org/a/121552)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/eendroroy/dockerize_rails. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bhttps%3A%2F%2Fgithub.com%2Feendroroy%2Fdockerize_rails.svg?type=large)](https://app.fossa.io/projects/git%2Bhttps%3A%2F%2Fgithub.com%2Feendroroy%2Fdockerize_rails?ref=badge_large)

