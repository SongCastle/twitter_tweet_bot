require 'uri'
require 'net/http'
require 'json'
require 'twitter_tweet_bot/api/http/base'

module TwitterTweetBot
  module API
    module HTTP
      module Post
        include Base

        URLENCODED_CONTENT_TYPE = 'application/x-www-form-urlencoded; charset=UTF-8'.freeze
        JSON_CONTENT_TYPE = 'application/json'.freeze

        def request_post_form(url, body, headers = {})
          request_post(
            url,
            URI.encode_www_form(body),
            headers.merge('content-type' => URLENCODED_CONTENT_TYPE)
          )
        end

        def request_post_json(url, body, headers = {})
          request_post(
            url,
            body.to_json,
            headers.merge('content-type' => JSON_CONTENT_TYPE)
          )
        end

        private

        def request_post(url, body, headers)
          uri = URI.parse(url)
          perform_request(
            uri,
            Net::HTTP::Post.new(uri.path, headers).tap { |req| req.body = body }
          )
        end

        private_constant :JSON_CONTENT_TYPE,
                         :URLENCODED_CONTENT_TYPE
      end
    end
  end
end
