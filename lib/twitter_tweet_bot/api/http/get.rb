require 'uri'
require 'net/http'
require 'twitter_tweet_bot/api/http/base'

module TwitterTweetBot
  module API
    module HTTP
      module Get
        include Base

        def request_get(url, body, headers = {})
          uri = build_uri(url, body)
          perform_request(
            uri, Net::HTTP::Get.new(uri, headers)
          )
        end

        private

        def build_uri(url, body)
          URI.parse(url).tap do |uri|
            uri.query = URI.encode_www_form(body)
          end
        end
      end
    end
  end
end
