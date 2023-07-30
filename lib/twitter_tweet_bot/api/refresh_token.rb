require 'twitter_tweet_bot/api/http'

module TwitterTweetBot
  module API
    class RefreshToken
      private_class_method :new

      include HTTP

      API_ENDPOTNT = 'https://api.twitter.com/2/oauth2/token'.freeze
      GRANT_TYPE = 'refresh_token'.freeze

      def self.fetch(client_id:, client_secret:, refresh_token:)
        new(client_id, client_secret)
          .fetch(refresh_token)
      end

      def initialize(client_id, client_secret)
        @client_id = client_id
        @client_secret = client_secret
      end

      def fetch(refresh_token)
        request(
          :post_form,
          API_ENDPOTNT,
          body_with(refresh_token),
          headers
        )
      end

      private

      attr_reader :client_id, :client_secret

      def body_with(refresh_token)
        {
          grant_type: GRANT_TYPE,
          refresh_token: refresh_token,
          client_id: client_id
        }
      end

      def headers
        basic_authorization_header(client_id, client_secret)
      end

      private_constant :API_ENDPOTNT,
                       :GRANT_TYPE
    end
  end
end
