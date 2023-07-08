require 'twitter_tweet_bot/api/params/boolean_param'
require 'twitter_tweet_bot/api/params/string_param'
require 'twitter_tweet_bot/api/params/hash_param'

module TwitterTweetBot
  module API
    module Params
      class TweetParams
        private_class_method :new

        # @yield [params]
        # @yieldparam params [TwitterTweetBot::API::Params::TweetParams]
        def self.build(&block)
          new(&block).build
        end

        # @see https://developer.twitter.com/en/docs/twitter-api/tweets/manage-tweets/api-reference/post-tweets
        AVAILABLE_PARAMS = {
          for_super_followers_only: BooleanParam,
          text: StringParam,
          direct_message_deep_link: StringParam,
          quote_tweet_id: StringParam,
          reply_settings: StringParam,
          geo: HashParam,
          media: HashParam,
          poll: HashParam,
          reply: HashParam
        }.freeze

        # @yield [params]
        # @yieldparam params [TwitterTweetBot::API::Params::TweetParams]
        def initialize(&block)
          block&.call(self)
        end

        def params
          @params ||= {}
        end
        alias build params

        private :params

        AVAILABLE_PARAMS.each do |name, param_klass|
          define_method("#{name}=") do |value|
            params.merge!(param_klass.build(name, value))
          end
        end

        private_constant :AVAILABLE_PARAMS
      end
    end
  end
end
