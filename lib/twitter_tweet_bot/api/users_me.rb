require 'twitter_tweet_bot/api/http'

module TwitterTweetBot
  module API
    class UsersMe
      private_class_method :new

      include HTTP

      API_ENDPOTNT = 'https://api.twitter.com/2/users/me'.freeze

      def self.fetch(access_token:, fields:, **)
        new(access_token).fetch(fields)
      end

      def initialize(access_token)
        @access_token = access_token
      end

      def fetch(fields)
        request(
          :get,
          API_ENDPOTNT,
          fields,
          bearer_authorization_header(access_token)
        )
      end

      private

      attr_accessor :access_token

      private_constant :API_ENDPOTNT
    end
  end
end
