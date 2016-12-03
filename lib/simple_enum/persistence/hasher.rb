module SimpleEnum
  module Persistence
    class Hasher
      include Enumerable

      attr_reader :enum_klass, :enum_key, :enum_value, :enum_mapping

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
        @enum_mapping = Array.new
        records.each do |record|
          key = record.send(enum_key)
          value =  record.send(enum_value)
          @enum_mapping.push([key, value])
        end
      end

      def each_pair &block
        @enum_mapping.each &block
      end
      alias_method :each, :each_pair

      def key? key
        @enum_mapping.any? { |k, v| k == key }
      end

      def value? value
        @enum_mapping.any? { |k, v| v == value }
      end

      def key value
        @enum_mapping.find { |k, v| v == value }[0]
      end

      def value key
        @enum_mapping.find { |k, v| k == key }[1]
      end
      alias_method :[], :value

      def keys
        @enum_mapping.map { |k, v| k }
      end

      def values
        @enum_mapping.map { |k, v| v }
      end

      def values_at *keys
        @enum_mapping.select { |k, v| keys.include? k }.map { |k, v| v }
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
