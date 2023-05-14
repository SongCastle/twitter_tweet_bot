require 'json'

module TwitterTweetBot
  module Cache
    class Store
      CACHE_BASE_KEY = 'twitter_tweet_bot'.freeze

      def initialize(name, provider)
        @name = name
        @provider = provider
      end

      def write(value)
        provider.write(cache_key, serialize_value(value))
      end

      def read
        deserialize_value(provider.read(cache_key))
      end

      private

      attr_reader :name, :provider

      def cache_key
        File.join(CACHE_BASE_KEY, name.to_s)
      end

      def serialize_value(value)
        value.to_json
      end

      def deserialize_value(value)
        return {} if value.nil?
        JSON.parse(value, symbolize_names: true)
      end

      private_constant :CACHE_BASE_KEY
    end
  end
end
