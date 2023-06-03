require 'active_support/concern'
require 'active_support/core_ext/class/attribute'

module TwitterTweetBot
  module Entity
    module Base
      extend ActiveSupport::Concern

      class_methods do
        # @param [Array] fields
        def act_as_entity(*fields)
          class_attribute :fields,
                          instance_writer: false,
                          default: fields

          attr_reader :row

          fields.each do |field|
            define_method(field) { target_fields[field] }
          end

          # @param [Hash] hash
          define_method(:initialize) { |hash| @row = Hash(hash) }

          define_method(:target_fields) { row }
          private :target_fields
        end

        # @param [Hash] hash
        def build(hash)
          new(hash)
        end
      end
    end
  end
end
