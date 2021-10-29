# BetterIndexName

Adds a little smarts to ActiveRecords index name generation to try and fit them into 63 characters or less for Postgres and MySQL.

Tries in the following ways:
- change polymorphic references to just the name of the relation
- change `index_` to `ix_`
- remove common strings from column names
- remove leading parts of the table name until there's only one
- change the columnn names used in the index to a hash
- change the table name to a hash if shorter
The end.  If it's still too long, you'll have to name it manually

## Installation

Add this line to your application's Gemfile:

```ruby
gem "better_index_name"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install better_index_name

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bsharpe/better_index_name. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/bsharpe/better_index_name/blob/development/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the BetterIndexName project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/better_index_name/blob/development/CODE_OF_CONDUCT.md).
