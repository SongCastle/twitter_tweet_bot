require 'twitter_tweet_bot'

require 'twitter_tweet_bot/cache/client_ext'
require 'twitter_tweet_bot/cache/configuration_ext'
require 'twitter_tweet_bot/cache/entity_ext'

module TwitterTweetBot
  Client.prepend(Cache::ClientExt)
  Configuration.prepend(Cache::ConfigurationExt)

  Entity::Authorization.include(Cache::EntityExt::Authorization)
  Entity::Token.include(Cache::EntityExt::Token)
end
