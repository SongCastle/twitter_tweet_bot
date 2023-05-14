require 'base64'
require 'securerandom'
require 'openssl'

module TwitterTweetBot
  module API
    class Authorization
      class SecureCode
        DEFAULT_CHALLENGE_SIZE = 64
        DEFAULT_CHALLENGE_METHOD = 'S256'.freeze
        DEFAULT_STATE_SIZE = 32

        class << self
          def code_verifier(size = DEFAULT_CHALLENGE_SIZE)
            encode(random_chars(size))
          end

          def state(size = DEFAULT_STATE_SIZE)
            encode(random_chars(size))
          end

          def code_challenge(verifier, challenge_method = DEFAULT_CHALLENGE_METHOD)
            case challenge_method
            when 'S256'
              encode(
                Base64.urlsafe_encode64(digest_by_sha256(verifier), padding: false)
              )
            else # 'plain'
              verifier
            end
          end

          private

          def random_chars(size)
            SecureRandom.urlsafe_base64(size / 4 * 3, false)
          end

          def digest_by_sha256(chars)
            OpenSSL::Digest::SHA256.digest(chars)
          end

          def encode(chars)
            chars.encode(Encoding::UTF_8)
          end
        end

        def initialize(code_verifier: nil, code_challenge_method: nil, state: nil)
          @code_verifier = code_verifier
          @code_challenge_method = code_challenge_method
          @state = state
        end

        def code_verifier
          @code_verifier ||= self.class.code_verifier
        end

        def code_challenge
          @code_challenge ||= \
            self.class.code_challenge(code_verifier, code_challenge_method)
        end

        def code_challenge_method
          @code_challenge_method ||= DEFAULT_CHALLENGE_METHOD
        end

        def state
          @state ||= self.class.state
        end

        private_constant :DEFAULT_CHALLENGE_SIZE,
                         :DEFAULT_CHALLENGE_METHOD,
                         :DEFAULT_STATE_SIZE
      end
    end
  end
end
