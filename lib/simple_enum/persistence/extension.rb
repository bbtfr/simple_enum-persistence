module SimpleEnum
  module Persistence
    module Extension
      def as_enum name, values, options = {}
        persistence = options.delete :persistence
        if persistence
          options[:with] ||= SimpleEnum.with.reject do |feature|
            [:attribute, :scope].include? feature
          end
          options[:map] = :persistence

          values = [ values ]
          values.push persistence if persistence.kind_of? Hash
        end

        super
      end
    end
  end
end

if SimpleEnum::Attribute.method_defined? :prepend
  SimpleEnum::Attribute.send :prepend, SimpleEnum::Persistence::Extension
else
  # Monkey Path Module::prepend for Ruby 1.9
  Attribute = SimpleEnum.send :remove_const, :Attribute
  module SimpleEnum::Attribute
    include Attribute
    include SimpleEnum::Persistence::Extension
  end
  Object.send :remove_const, :Attribute
end

