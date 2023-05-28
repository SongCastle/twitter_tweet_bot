require 'twitter_tweet_bot/entity/base'

module TwitterTweetBot
  module Entity
    class Tweet
      include Base

      act_as_entity(
        :id,
        :text,
        :edit_history_tweet_ids
      )

      def self.build(json)
        super(Hash(json)[:data])
      end
    end
  end
end
