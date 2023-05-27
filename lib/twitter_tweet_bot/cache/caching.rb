module TwitterTweetBot
  module Cache
    module Caching
      def cache
        config.cache
      end

      def with_cache(&block)
        current_cache = read_cache
        result = yield(current_cache)
        write_cache(current_cache, result)

        result
      end

      private

      def read_cache
        cache.read || {}
      end

      def write_cache(current, value)
        cache.write(current.merge(**to_cache_object(value)))
      end

      def to_cache_object(object)
        return {} unless object.respond_to?(:to_cache)

        object.to_cache
      end
    end
  end
end
