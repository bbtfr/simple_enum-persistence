module SimpleEnum
  module Persistence
    module Extension
      def self.included base
        base.module_eval do
          alias_method :as_enum_without_persistence, :as_enum
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

            as_enum_without_persistence name, values, options
          end
        end
      end

      def generate_enum_persistence_extension_for enum, accessor
      end
    end
  end
end

SimpleEnum.register_generator :persistence, SimpleEnum::Persistence::Extension
