require 'uri'
require 'net/http'

module TwitterTweetBot
  module API
    module HTTP
      module Headers
        BASIC_AUTHORIZATION = 'Basic %<credentials>s'.freeze
        BEARER_AUTHORIZATION = 'Bearer %<credentials>s'.freeze

        def basic_authorization_header(credentials)
          { authorization: format(BASIC_AUTHORIZATION, credentials: credentials) }
        end

        def bearer_authorization_header(credentials)
          { authorization: format(BEARER_AUTHORIZATION, credentials: credentials) }
        end
      end
    end
  end
end
