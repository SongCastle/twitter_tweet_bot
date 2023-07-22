require 'twitter_tweet_bot/api/http'
require 'twitter_tweet_bot/api/params/users_me_params'

module TwitterTweetBot
  module API
    class UsersMe
      private_class_method :new

      include HTTP

      API_ENDPOTNT = 'https://api.twitter.com/2/users/me'.freeze

      # @param [String] access_token
      # @yield [params]
      # @yieldparam params [TwitterTweetBot::API::Params::UsersMeParams]
      def self.fetch(access_token:, &block)
        new(access_token).fetch(
          Params::UsersMeParams.build(&block)
        )
      end

      def initialize(access_token)
        @access_token = access_token
      end

      def fetch(params)
        request(
          :get,
          API_ENDPOTNT,
          params,
          bearer_authorization_header(access_token)
        )
      end

      private

      attr_accessor :access_token

      private_constant :API_ENDPOTNT
    end
  end
end
