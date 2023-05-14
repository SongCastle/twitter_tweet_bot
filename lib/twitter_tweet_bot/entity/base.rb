require 'active_support/concern'
require 'active_support/core_ext/class/attribute'

module TwitterTweetBot
  module Entity
    module Base
      extend ActiveSupport::Concern

      class_methods do
        def act_as_entity(*fields)
          class_attribute :fields,
                          instance_writer: false,
                          default: fields

          attr_reader(*fields)
        end
      end

      def initialize(json)
        set_fields!(Hash(json))
      end

      private

      def set_fields!(hash)
        fields.each do |field|
          instance_variable_set(:"@#{field}", hash[field])
        end
      end
    end
  end
end
