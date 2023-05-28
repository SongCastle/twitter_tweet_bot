require 'twitter_tweet_bot/api'

module TwitterTweetBot
  class Client
    module API
      def authorize(code_verifier = nil, code_challenge_method = nil, state = nil)
        TwitterTweetBot::API::Authorization.authorize(
          **params_with_config(
            code_verifier: code_verifier,
            code_challenge_method: code_challenge_method,
            state: state
          )
        )
      end

      def fetch_token(code, code_verifier)
        TwitterTweetBot::API::AccessToken.fetch(
          **params_with_config(
            code: code,
            code_verifier: code_verifier
          )
        )
      end

      def refresh_token(refresh_token)
        TwitterTweetBot::API::RefreshToken.fetch(
          **params_with_config(refresh_token: refresh_token)
        )
      end

      def post_tweet(access_token, text)
        TwitterTweetBot::API::Tweet.post(
          **params_with_config(access_token: access_token, text: text)
        )
      end

      def users_me(access_token, fields = {})
        TwitterTweetBot::API::UsersMe.fetch(
          **params_with_config(access_token: access_token, fields: fields)
        )
      end

      private

      def params_with_config(**params)
        config.to_hash.merge(**params)
      end
    end
  end
end
