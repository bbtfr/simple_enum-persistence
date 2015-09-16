# SimpleEnum::Persistence

SimpleEnum::Multiple is extension of SimpleEnum, which brings data persistence support to SimpleEnum.

## ActiveRecord Quick start

Let's say we have a model Tag, we want to use it as enum data, just add this to a model:
```ruby
as_enum :tag, Tag, persistence: true
```

Then SimpleEnum will use `Tag.all` as enum data, `tag.name` as enum key and `tag.id` as enum value, if we want to use a field rather than `:name` as enum key:
```ruby
as_enum :tag, Tag, persistence: { key: :name, value: :id }
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

