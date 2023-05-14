require 'twitter_tweet_bot/cache/caching'

module TwitterTweetBot
  module Cache
    module ClientExt
      include Caching

      def authorization(*)
        with_cache { super }
      end

      def fetch_token(*args)
        with_cache { |cache| super(*args, cache[:code_verifier]) }
      end

      def refresh_token
        with_cache { |cache| super(cache[:refresh_token]) }
      end

      def post_tweet(*args)
        with_cache { |cache| super(cache[:access_token], *args) }
      end

      def users_me(*args)
        with_cache { |cache| super(cache[:access_token], *args) }
      end
    end
  end
end
