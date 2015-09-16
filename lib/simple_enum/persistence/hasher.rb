module SimpleEnum
  module Persistence
    class Hasher < Hash
      attr_reader :enum_klass, :enum_key, :enum_value

      def initialize options
        @enum_klass = options[0]
        options = options[1] || Hash.new
        @enum_key = options[:key] || :name
        @enum_value = options[:value] || :id

        unless enum_klass.method_defined? :update_enum_hashers
          enum_klass.instance_eval do
            def enum_hashers
              @enum_hashers ||= []
            end

            def update_enum_hashers
              records = all.to_a
              enum_hashers.each do |hasher|
                hasher.enum_replace records
              end
            end
          end

          enum_klass.class_eval do
            def update_enum_hashers
              self.class.update_enum_hashers
            end

            after_commit :update_enum_hashers
          end
        end

        enum_klass.enum_hashers.push self
        enum_replace enum_klass.all
      end

      def enum_replace records
        hash = Hash.new
        records.each do |record|
          hash[record.send(enum_key)] = record.send(enum_value)
        end
        replace hash
      end

      # Do nothing when freeze, cause we have to motify the hash later
      def freeze
        self
      end

      class << self
        alias_method :call, :new
      end
    end

    SimpleEnum::Hasher::HASHERS.merge!({
      persistence: Hasher
    })
  end
end
