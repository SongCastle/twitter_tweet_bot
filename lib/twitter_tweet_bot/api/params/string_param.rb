module TwitterTweetBot
  module API
    module Params
      module StringParam
        def self.build(key, value)
          return {} unless value.is_a?(String)

          { key => value }
        end
      end
    end
  end
end
