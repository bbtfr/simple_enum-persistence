module ActiveRecordSupport
  def self.connection
    @connection_pool ||= ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'
    ActiveRecord::Base.connection
  end

  def self.included(base)
    base.before(:each) { self.reset_active_record }
  end

  def reset_active_record
    ActiveRecordSupport.connection.create_table :dummies, force: true do |t|
      t.column :name, :string
      t.column :gender_cd, :integer
    end

    ActiveRecordSupport.connection.create_table :genders, force: true do |t|
      t.column :name, :string
    end

    Gender.create(name: "male")
    Gender.create(name: "female")
  end
end

class Gender < ActiveRecord::Base
end

# Behave like the railtie.rb
ActiveRecord::Base.send :extend, SimpleEnum::Attribute
ActiveRecord::Base.send :extend, SimpleEnum::Translation
