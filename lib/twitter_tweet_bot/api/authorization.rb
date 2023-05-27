require 'twitter_tweet_bot/api/authorization/secure_code'
require 'twitter_tweet_bot/api/http'

module TwitterTweetBot
  module API
    class Authorization
      private_class_method :new

      include HTTP

      AUTH_URL = 'https://twitter.com/i/oauth2/authorize'.freeze
      RESPONSE_TYPE = 'code'.freeze

      def self.authorization(
        client_id:,
        redirect_uri:,
        scopes:,
        code_verifier:,
        code_challenge_method:,
        state:,
        **
      )
        new(client_id, redirect_uri, scopes)
          .authorization(code_verifier, code_challenge_method, state)
      end

      def initialize(client_id, redirect_uri, scopes)
        @client_id = client_id
        @redirect_uri = redirect_uri
        @scopes = scopes
      end

      def authorization(code_verifier, code_challenge_method, state)
        secure_code = Authorization::SecureCode.new(
          code_verifier: code_verifier,
          code_challenge_method: code_challenge_method,
          state: state
        )
        uri = build_uri(AUTH_URL, build_body(secure_code))
        as_hash(uri.to_s, secure_code)
      end

      private

      attr_reader :client_id, :redirect_uri, :scopes

      def build_body(secure_code)
        {
          response_type: RESPONSE_TYPE,
          redirect_uri: redirect_uri,
          client_id: client_id,
          scope: scopes.join(' '),
          code_challenge: secure_code.code_challenge,
          code_challenge_method: secure_code.code_challenge_method,
          state: secure_code.state
        }
      end

      def as_hash(url, secure_code)
        {
          url: url,
          code_verifier: secure_code.code_verifier,
          state: secure_code.state
        }
      end

      private_constant :AUTH_URL,
                       :RESPONSE_TYPE
    end
  end
end
