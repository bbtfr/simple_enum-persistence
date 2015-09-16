module SimpleEnum
  module Persistence
    module Attribute
      def as_enum name, values, options = {}
        persistence = options.delete :persistence
        if persistence
          options[:with] ||= SimpleEnum.with.reject do |feature|
            %i(attribute scope).include? feature
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
