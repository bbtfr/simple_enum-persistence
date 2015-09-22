# SimpleEnum::Persistence

[![Travis](https://img.shields.io/travis/bbtfr/simple_enum-persistence.svg)](https://travis-ci.org/bbtfr/simple_enum-persistence) 
[![Gem](https://img.shields.io/gem/v/simple_enum-persistence.svg)](https://rubygems.org/gems/simple_enum-persistence)

SimpleEnum::Persistence is extension of SimpleEnum, which brings data persistence support to SimpleEnum.
Sometimes, we need to use one of our Model as enum data source, in order to add/remove enum type dynamically, SimpleEnum::Persistence is built for this!

## Why not ActiveRecord association?

1. SimpleEnum is a great library, which brings a lot of benefits to create enum-like fields;

2. SimpleEnum::Persistence cache all enums in memory for better performance, and it will reload when database changes (with `after_save` callback).

## ActiveRecord Quick start

Let's say we have a model Tag, we want to use it as enum data, just add this to a model:
```ruby
class Post
  as_enum :tag, Tag, persistence: true
end
```

Then SimpleEnum will use `Tag.all` as enum data, `tag.name` as enum key and `tag.id` as enum value, if we want to use a field rather than `:name` as enum key:
```ruby
class Post
  as_enum :tag, Tag, persistence: { key: :name, value: :id }
end
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

