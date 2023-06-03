module TwitterTweetBot
  module API
    class UsersMe
      module Params
        FIELDS_KEYS = {
          expansions: 'expansions',
          tweet_fields: 'tweet.fields',
          user_fields: 'user.fields'
        }.freeze
        FIELDS_DELIMITER = ','.freeze

        # @param [Hash] params
        # @option params [String] :expansions
        # @option params [String|Array] :tweet_fields
        # @option params [String|Array] :user_fields
        class << self
          def build(params)
            slice(params)
              .transform_keys { |key| FIELDS_KEYS[key] }
              .transform_values do |value|
                next value unless value.is_a?(Array)

                value.join(FIELDS_DELIMITER)
              end
          end

          private

          def slice(params)
            params.slice(*FIELDS_KEYS.keys)
          end
        end

        private_constant :FIELDS_KEYS, :FIELDS_DELIMITER
      end

      private_constant :Params
    end
  end
end
