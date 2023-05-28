require 'base64'
require 'uri'
require 'net/http'

module TwitterTweetBot
  module API
    module HTTP
      module Headers
        BASIC_AUTHORIZATION = 'Basic %<credentials>s'.freeze
        BEARER_AUTHORIZATION = 'Bearer %<credentials>s'.freeze

        def basic_authorization_header(user, password)
          {
            authorization: format(
              BASIC_AUTHORIZATION,
              credentials: authorization_credentials(user, password)
            )
          }
        end

        def bearer_authorization_header(credentials)
          { authorization: format(BEARER_AUTHORIZATION, credentials: credentials) }
        end

        private

        def authorization_credentials(user, password)
          Base64.strict_encode64("#{user}:#{password}")
        end
      end
    end
  end
end
