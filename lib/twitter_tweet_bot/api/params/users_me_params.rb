require 'twitter_tweet_bot/api/params/comma_separated_param'
require 'twitter_tweet_bot/api/params/plain_param'

module TwitterTweetBot
  module API
    module Params
      class UsersMeParams
        private_class_method :new

        # @yield [params]
        # @yieldparam params [TwitterTweetBot::API::Params::UsersMeParams]
        def self.build(&block)
          new(&block).build
        end

        # @yield [params]
        # @yieldparam params [TwitterTweetBot::API::Params::UsersMeParams]
        def initialize(&block)
          block&.call(self)
        end

        def params
          @params ||= {}
        end
        alias build params

        def expansions=(value)
          params.merge!(PlainParam.build('expansions', value))
        end

        def tweet_fields=(value)
          params.merge!(CommaSeparatedParam.build('tweet.fields', value))
        end

        def user_fields=(value)
          params.merge!(CommaSeparatedParam.build('user.fields', value))
        end

        private :params
      end
    end
  end
end
