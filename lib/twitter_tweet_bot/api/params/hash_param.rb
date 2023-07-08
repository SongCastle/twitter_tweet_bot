module TwitterTweetBot
  module API
    module Params
      module HashParam
        def self.build(key, value)
          return {} unless value.is_a?(Hash)

          { key => value }
        end
      end
    end
  end
end
