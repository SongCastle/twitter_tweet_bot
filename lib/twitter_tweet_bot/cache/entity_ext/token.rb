require 'twitter_tweet_bot/cache/entity_ext/base'

module TwitterTweetBot
  module Cache
    module EntityExt
      module Token
        include Base

        act_as_cache_entity(
          :access_token,
          :refresh_token
        )
      end
    end
  end
end
