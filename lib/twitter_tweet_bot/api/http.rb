require 'twitter_tweet_bot/api/http/error'
require 'twitter_tweet_bot/api/http/headers'
require 'twitter_tweet_bot/api/http/get'
require 'twitter_tweet_bot/api/http/post'

module TwitterTweetBot
  module API
    module HTTP
      include Error
      include Headers
      include Get
      include Post

      def request(method, url, body, headers)
        response = send("request_#{method}", url, body, headers)
        success_or_fail!(response)
      end

      private

      def success_or_fail!(response)
        case response
        when Net::HTTPSuccess, Net::HTTPRedirection
          response.body
        else
          request_error!(response.code, response.body)
        end
      end
    end
  end
end
