require 'twitter_tweet_bot/api'

module TwitterTweetBot
  class Client
    module API
      def authorize(code_verifier = nil, code_challenge_method = nil, state = nil)
        TwitterTweetBot::API::Authorization.authorize(
          **slice_config(:client_id, :redirect_uri, :scopes),
          code_verifier: code_verifier,
          code_challenge_method: code_challenge_method,
          state: state
        )
      end

      def fetch_token(code, code_verifier)
        TwitterTweetBot::API::AccessToken.fetch(
          **slice_config(:client_id, :client_secret, :redirect_uri),
          code: code,
          code_verifier: code_verifier
        )
      end

      def refresh_token(refresh_token)
        TwitterTweetBot::API::RefreshToken.fetch(
          **slice_config(:client_id, :client_secret),
          refresh_token: refresh_token
        )
      end

      def post_tweet(access_token, text, &block)
        TwitterTweetBot::API::Tweet.post(
          access_token: access_token,
          text: text,
          &block
        )
      end

      def users_me(access_token, &block)
        TwitterTweetBot::API::UsersMe.fetch(
          access_token: access_token,
          &block
        )
      end

      private

      def slice_config(*keys)
        config.to_hash.slice(*keys)
      end
    end
  end
end
