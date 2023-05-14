require 'twitter_tweet_bot/cache/store'

module TwitterTweetBot
  module Cache
    module ConfigrationExt
      attr_accessor :cache_provider, :cache

      def initialize(cache_provider: nil, **kwargs)
        @cache_provider = cache_provider
        super(**kwargs)
      end

      def cache
        @cache ||= Store.new(name, cache_provider)
      end
    end
  end
end
