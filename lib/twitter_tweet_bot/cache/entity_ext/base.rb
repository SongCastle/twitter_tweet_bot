require 'active_support/concern'
require 'active_support/core_ext/module/attribute_accessors'

module TwitterTweetBot
  module Cache
    module EntityExt
      module Base
        extend ActiveSupport::Concern

        class_methods do
          def act_as_cache_entity(*cache_fields)
            mattr_reader :cache_fields,
                         default: cache_fields
          end
        end

        def to_cache
          cache_fields.each_with_object({}) do |cache_field, hash|
            next hash unless respond_to?(cache_field)

            value = send(cache_field)
            next hash if value.nil?

            hash[cache_field] = value
          end
        end
      end
    end
  end
end
