require 'twitter_tweet_bot/cache/caching'

module TwitterTweetBot
  module Cache
    module ClientExt
      include Caching

      def authorization(code_verifier = nil, code_challenge_method = nil, state = nil)
        with_cache { super }
      end

      def fetch_token(code)
        with_cache { |cache| super(code, cache[:code_verifier]) }
      end

      def refresh_token
        with_cache { |cache| super(cache[:refresh_token]) }
      end

      def post_tweet(text)
        with_cache { |cache| super(cache[:access_token], text) }
      end
    end
  end
end
