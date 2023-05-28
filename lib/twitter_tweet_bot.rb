require 'twitter_tweet_bot/client'
require 'twitter_tweet_bot/configration'
require 'twitter_tweet_bot/version'

require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/core_ext/module/delegation'

module TwitterTweetBot
  NoConfigrationError = Class.new(StandardError).freeze

  mattr_accessor :default_config

  class << self
    def configure(&block)
      self.default_config = Configration.new(&block)
    end

    def client(config = nil)
      Client.new(config || default_config!)
    end

    delegate :authorize,
             :fetch_token,
             :refresh_token,
             :post_tweet,
             :users_me,
             to: :client

    private

    def default_config!
      default_config or raise NoConfigrationError
    end
  end
end
