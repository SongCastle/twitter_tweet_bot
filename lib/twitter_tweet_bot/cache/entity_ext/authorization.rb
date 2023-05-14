require 'twitter_tweet_bot/cache/entity_ext/base'

module TwitterTweetBot
  module Cache
    module EntityExt
      module Authorization
        include Base

        act_as_cache_entity(
          :code_verifier,
          :state
        )
      end
    end
  end
end
