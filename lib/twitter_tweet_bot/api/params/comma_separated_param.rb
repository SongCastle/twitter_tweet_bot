module TwitterTweetBot
  module API
    module Params
      module CommaSeparatedParam
        DELIMITER = ','.freeze

        def self.build(key, value)
          { key => formed_value(value) }
        end

        def self.formed_value(value)
          return value unless value.is_a?(Array)

          value.join(DELIMITER)
        end

        private_constant :DELIMITER
      end
    end
  end
end
