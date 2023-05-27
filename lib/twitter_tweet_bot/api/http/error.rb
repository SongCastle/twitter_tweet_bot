module TwitterTweetBot
  module API
    module HTTP
      module Error
        class RequestFaild < StandardError
          def initialize(code, body)
            super(format_message(code, body))
          end

          private

          def format_message(code, body)
            [code, body].join("\n")
          end
        end

        def request_error!(code, body)
          raise RequestFaild.new(code, body)
        end
      end
    end
  end
end
