require 'simple_enum/persistence'

module SimpleEnum
  module Persistence
    class Railtie < Rails::Railtie

      initializer 'simple_enum.persistence.extend_active_record' do
        ActiveSupport.on_load(:active_record) do
          ActiveRecord::Base.send :extend, SimpleEnum::Persistence::Attribute
        end
      end

    end
  end
end
