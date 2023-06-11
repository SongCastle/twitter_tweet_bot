require 'twitter_tweet_bot/client'
require 'twitter_tweet_bot/configuration'
require 'twitter_tweet_bot/version'

require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/core_ext/module/delegation'

module TwitterTweetBot
  NoConfigurationError = Class.new(StandardError).freeze

  mattr_accessor :default_config

  class << self
    def configure(&block)
      self.default_config = Configuration.new(&block)
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
      default_config or raise NoConfigurationError
    end
  end
end
