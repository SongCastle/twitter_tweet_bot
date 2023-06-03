require 'twitter_tweet_bot/api/http'
require 'twitter_tweet_bot/api/users_me/params'

module TwitterTweetBot
  module API
    class UsersMe
      private_class_method :new

      include HTTP

      API_ENDPOTNT = 'https://api.twitter.com/2/users/me'.freeze

      # @param [String] access_token
      # @param [Hash] params
      # @option params [String|Array] :tweet_fields
      # @option params [String|Array] :user_fields
      def self.fetch(access_token:, params:, **)
        new(access_token).fetch(params)
      end

      def initialize(access_token)
        @access_token = access_token
      end

      def fetch(params)
        request(
          :get,
          API_ENDPOTNT,
          Params.build(params),
          bearer_authorization_header(access_token)
        )
      end

      private

      attr_accessor :access_token

      private_constant :API_ENDPOTNT
    end
  end
end
