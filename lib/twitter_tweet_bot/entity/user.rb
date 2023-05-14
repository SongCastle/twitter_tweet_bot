
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

      def initialize(data)
        super Hash(data)[:data]
      end
    end
  end
end
