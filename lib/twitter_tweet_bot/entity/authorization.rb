require 'twitter_tweet_bot/entity/base'

module TwitterTweetBot
  module Entity
    class Authorization
      include Base

      act_as_entity(
        :url,
        :code_verifier,
        :state
      )
    end
  end
end
