require 'twitter_tweet_bot/entity/base'

module TwitterTweetBot
  module Entity
    class Token
      include Base

      act_as_entity(
        :token_type,
        :expires_in,
        :access_token,
        :refresh_token,
        :scope
      )
    end
  end
end
