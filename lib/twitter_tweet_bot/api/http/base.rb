require 'net/http'

module TwitterTweetBot
  module API
    module HTTP
      module Base
        def perform_request(uri, request)
          Net::HTTP.start(
            uri.host, uri.port, use_ssl: uri.scheme == 'https'
          ) do |http|
            http.request(request)
          end
        end
      end
    end
  end
end
