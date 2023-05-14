require 'base64'
require 'twitter_tweet_bot/api/http'

module TwitterTweetBot
  module API
    class AccessToken
      private_class_method :new

      include HTTP

      API_ENDPOTNT = 'https://api.twitter.com/2/oauth2/token'.freeze
      GRANT_TYPE = 'authorization_code'.freeze

      def self.fetch(
        client_id:,
        client_secret:,
        redirect_uri:,
        code:,
        code_verifier:,
        **
      )
        new(client_id, client_secret, redirect_uri)
          .fetch(code, code_verifier)
      end

      def initialize(client_id, client_secret, redirect_uri)
        @client_id = client_id
        @client_secret = client_secret
        @redirect_uri = redirect_uri
      end

      def fetch(code, code_verifier)
        request(
          :post_form,
          API_ENDPOTNT,
          body_with(code, code_verifier),
          headers
        )
      end

      private

      attr_reader :client_id, :client_secret, :redirect_uri

      def body_with(code, code_verifier)
        {
          grant_type: GRANT_TYPE,
          code: code,
          code_verifier: code_verifier,
          redirect_uri: redirect_uri
        }
      end

      def headers
        basic_authorization_header(
          Base64.strict_encode64("#{client_id}:#{client_secret}")
        )
      end

      private_constant :API_ENDPOTNT,
                       :GRANT_TYPE
    end
  end
end
