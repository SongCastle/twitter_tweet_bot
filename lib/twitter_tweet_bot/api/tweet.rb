require 'twitter_tweet_bot/api/http'
require 'twitter_tweet_bot/api/params/tweet_params'

module TwitterTweetBot
  module API
    class Tweet
      private_class_method :new

      include HTTP

      API_ENDPOTNT = 'https://api.twitter.com/2/tweets'.freeze

      # @param [String] access_token
      # @param [String] text
      # @yield [params]
      # @yieldparam params [TwitterTweetBot::API::Params::TweetParams]
      def self.post(access_token:, text:, &block)
        new(access_token).post(
          Params::TweetParams.build do |params|
            params.text = text
            block&.call(params)
          end
        )
      end

      def initialize(access_token)
        @access_token = access_token
      end

      def post(params)
        request(
          :post_json,
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
