require 'twitter_tweet_bot/entity/base'

module TwitterTweetBot
  module Entity
    class User
      include Base

      act_as_entity(
        :id,
        :name,
        :username
      )

      def self.build(json)
        super(Hash(json)[:data])
      end
    end
  end
end
