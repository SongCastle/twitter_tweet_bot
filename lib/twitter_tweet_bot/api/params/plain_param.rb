module TwitterTweetBot
  module API
    module Params
      module PlainParam
        def self.build(key, value)
          { key => value }
        end
      end
    end
  end
end
