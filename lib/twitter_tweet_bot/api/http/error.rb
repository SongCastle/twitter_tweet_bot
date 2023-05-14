module TwitterTweetBot
  module API
    module HTTP
      module Error
        class RequestFaild < StandardError
          attr_reader :code, :body

          def initialize(code, body)
            @code = code
            @body = body
          end

          def inspect
            "#<#{self.class} #{code} #{body}>"
          end
        end

        def request_error!(code, body)
          raise RequestFaild.new(code, body)
        end
      end
    end
  end
end
