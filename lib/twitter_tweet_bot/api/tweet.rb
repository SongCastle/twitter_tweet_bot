require 'twitter_tweet_bot/api/http'

module TwitterTweetBot
  module API
    class Tweet
      private_class_method :new

      include HTTP

      API_ENDPOTNT = 'https://api.twitter.com/2/tweets'.freeze

      def self.post(access_token:, text:, **)
        new(access_token).post(text)
      end

      def initialize(access_token)
        @access_token = access_token
      end

      def post(text)
        request(
          :post_json,
          API_ENDPOTNT,
          { text: text },
          bearer_authorization_header(access_token)
        )
      end

      private

      attr_accessor :access_token

      private_constant :API_ENDPOTNT
    end
  end
end
