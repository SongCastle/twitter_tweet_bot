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

      private

      def target_fields
        Hash(row[:data])
      end
    end
  end
end
