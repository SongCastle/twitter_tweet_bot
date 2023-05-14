require 'twitter_tweet_bot/client/api'
require 'twitter_tweet_bot/client/entity'

module TwitterTweetBot
  class Client
    include API
    include Entity

    def initialize(config)
      @config = config
    end

    private

    attr_accessor :config
  end
end
