module TwitterTweetBot
  module API
    module Params
      module BooleanParam
        def self.build(key, value)
          return {} unless value.is_a?(TrueClass) || value.is_a?(FalseClass)

          { key => value }
        end
      end
    end
  end
end
