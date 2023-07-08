module TwitterTweetBot
  module API
    module Params
      module StringParam
        def self.build(key, value)
          { key => value.to_s }
        end
      end
    end
  end
end
