require 'json'
require 'twitter_tweet_bot/entity'

module TwitterTweetBot
  class Client
    module Entity
      def authorization(*)
        with_entity(TwitterTweetBot::Entity::Authorization) { super }
      end

      def fetch_token(*)
        with_entity(TwitterTweetBot::Entity::Token) { parse_json(super) }
      end

      def refresh_token(*)
        with_entity(TwitterTweetBot::Entity::Token) { parse_json(super) }
      end

      def post_tweet(*)
        with_entity(TwitterTweetBot::Entity::Tweet) { parse_json(super) }
      end

      def users_me(*)
        with_entity(TwitterTweetBot::Entity::User) { parse_json(super) }
      end

      private

      def with_entity(entity_klass, &block)
        entity_klass.new(block.call)
      end

      def parse_json(body)
        JSON.parse(body, symbolize_names: true)
      end
    end
  end
end
