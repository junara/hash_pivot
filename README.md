[![codecov](https://codecov.io/gh/junara/hash_pivot/branch/main/graph/badge.svg?token=NNQ37LG8R7)](https://codecov.io/gh/junara/hash_pivot)

# HashPivot

Pivot Array of Hash or Array of Struct or ActiveRecord::Relation.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add hash_pivot

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install hash_pivot

## Usage

### Pivot Array of Hash

#### Prepare data

Prepare Array of Hash.

```ruby
 data = [
  { id: 1, role: 'guest', team: 'rabbit', age: 1 },
  { id: 2, role: 'guest', team: 'mouse', age: 2 },
  { id: 3, role: 'guest', team: 'rabbit', age: 3 },
  { id: 4, role: 'admin', team: 'mouse', age: 4 }
]
```

#### Basic usage

Grouping by `:role` and pivot in `:team`. Pivot column is `rabbit or mouse` .

```ruby
HashPivot.pivot(data, :role, :team, %w[rabbit mouse])

# [{ :role => "guest",
#    "rabbit" => [{ :id => 1, :role => "guest", :team => "rabbit", :age => 1 }, { :id => 3, :role => "guest", :team => "rabbit", :age => 3 }],
#    "mouse" => [{ :id => 2, :role => "guest", :team => "mouse", :age => 2 }] },
#  { :role => "admin", "rabbit" => [], "mouse" => [{ :id => 4, :role => "admin", :team => "mouse", :age => 4 }] }]
```

Grouping by `:role` and pivot in `:team`.

Pivot column is nil. This means that pivot column is automatically configured.

```ruby
HashPivot.pivot(data, :role, :team, nil)

# [{ :role => "guest",
#    "rabbit" => [{ :id => 1, :role => "guest", :team => "rabbit", :age => 1 }, { :id => 3, :role => "guest", :team => "rabbit", :age => 3 }],
#    "mouse" => [{ :id => 2, :role => "guest", :team => "mouse", :age => 2 }] },
#  { :role => "admin", "mouse" => [{ :id => 4, :role => "admin", :team => "mouse", :age => 4 }] }]
```

#### Pivot with summarize.

Pivot data is summarized by block.

Age is summarized by block.

```ruby
HashPivot.pivot(data, :role, :team, %w[rabbit mouse]) { |array| array.sum { |h| h[:age] } }

# [{ :role => "guest", "rabbit" => 4, "mouse" => 2 }, { :role => "admin", "rabbit" => 0, "mouse" => 4 }]
```


### Pivot Array of Struct

#### Prepare data

Prepare Array of Struct.

```ruby
HashPivotUserStruct = Struct.new(:id, :role, :team, :age, keyword_init: true)
data = [
  HashPivotUserStruct.new(id: 1, role: 'guest', team: 'rabbit', age: 1),
  HashPivotUserStruct.new(id: 2, role: 'guest', team: 'mouse', age: 2),
  HashPivotUserStruct.new({ id: 3, role: 'guest', team: 'rabbit', age: 3 }),
  HashPivotUserStruct.new({ id: 4, role: 'admin', team: 'mouse', age: 4 })
]
```

#### Basic usage

Grouping by `:role` and pivot in `:team`. Pivot column is `rabbit or mouse` .

```ruby
HashPivot.pivot(data, :role, :team, %w[rabbit mouse], repository: HashPivot::Repository::StructRepository)

# [{ :role => "guest",
#    "rabbit" => [{ :id => 1, :role => "guest", :team => "rabbit", :age => 1 }, { :id => 3, :role => "guest", :team => "rabbit", :age => 3 }],
#    "mouse" => [{ :id => 2, :role => "guest", :team => "mouse", :age => 2 }] },
#  { :role => "admin", "rabbit" => [], "mouse" => [{ :id => 4, :role => "admin", :team => "mouse", :age => 4 }] }]
```


### Pivot Array of ActiveRecord::Relation

#### Prepare data

Prepare Array of ActiveRecord::Relation.

```ruby
class MigrateSqlDatabase < ActiveRecord::Migration[6.1]
  def self.up
    create_table(:hash_pivot_users) do |t|
      t.string :role
      t.string :team
      t.integer :age
    end
  end
end
```

```ruby
HashPivotUser.destroy_all
HashPivotUser.create(:hash_pivot_user, id: 1, role: 'guest', team: 'rabbit', age: 1)
HashPivotUser.create(:hash_pivot_user, id: 2, role: 'guest', team: 'mouse', age: 2)
HashPivotUser.create(:hash_pivot_user, id: 3, role: 'guest', team: 'rabbit', age: 3)
HashPivotUser.create(:hash_pivot_user, id: 4, role: 'admin', team: 'mouse', age: 4)
```

#### Basic usage

Grouping by `:role` and pivot in `:team`. Pivot column is `rabbit or mouse` .

```ruby
HashPivot.pivot(data, :role, :team, %w[rabbit mouse], repository: HashPivot::Repository::ActiveRecordRepository)

# [{ :role => "guest",
#    "rabbit" => [{ :id => 1, :role => "guest", :team => "rabbit", :age => 1 }, { :id => 3, :role => "guest", :team => "rabbit", :age => 3 }],
#    "mouse" => [{ :id => 2, :role => "guest", :team => "mouse", :age => 2 }] },
#  { :role => "admin", "rabbit" => [], "mouse" => [{ :id => 4, :role => "admin", :team => "mouse", :age => 4 }] }]
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/hash_pivot. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/hash_pivot/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the HashPivot project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/hash_pivot/blob/main/CODE_OF_CONDUCT.md).
