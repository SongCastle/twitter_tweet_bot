RSpec.describe TwitterTweetBot::API::Authorization do
  describe '::authorize' do
    subject(:authorization) do
      described_class.authorize(**params)
    end

    context 'when authorization params are given' do
      let(:params) do
        {
          client_id: Faker::Alphanumeric.alpha(number: 5),
          redirect_uri: Faker::Internet.url,
          scopes: %w[tweet.read tweet.write users.read offline.access],
          code_verifier: Faker::Alphanumeric.alpha(number: 5),
          code_challenge_method: 'S256',
          state: Faker::Alphanumeric.alpha(number: 5)
        }
      end

      before do
        allow(TwitterTweetBot::API::Authorization::SecureCode).to(
          receive(:code_challenge).and_return('*' * 5)
        )
      end

      it 'builds authorization information as Hash' do
        expect(authorization).to be_a(Hash)
        expect(authorization[:url]).to eq(
          URI('https://twitter.com/i/oauth2/authorize').tap do |uri|
            uri.query = URI.encode_www_form(
              {
                response_type: 'code',
                redirect_uri: params[:redirect_uri],
                client_id: params[:client_id],
                scope: params[:scopes].join(' '),
                code_challenge: '*' * 5,
                code_challenge_method: params[:code_challenge_method],
                state: params[:state]
              }
            )
          end.to_s
        )
        expect(authorization[:code_verifier]).to eq(params[:code_verifier])
        expect(authorization[:state]).to eq(params[:state])

        expect(TwitterTweetBot::API::Authorization::SecureCode).to(
          have_received(:code_challenge)
            .with(params[:code_verifier], params[:code_challenge_method])
            .once
        )
      end
    end

    context 'when ONLY specific authorization params are given' do
      let(:params) do
        {
          client_id: Faker::Alphanumeric.alpha(number: 5),
          redirect_uri: Faker::Internet.url,
          scopes: %w[tweet.read tweet.write users.read offline.access],
          code_verifier: nil,
          code_challenge_method: nil,
          state: nil
        }
      end

      before do
        allow(TwitterTweetBot::API::Authorization::SecureCode).to(
          receive(:code_verifier).and_return('*' * 3)
        )

        allow(TwitterTweetBot::API::Authorization::SecureCode).to(
          receive(:state).and_return('*' * 4)
        )

        allow(TwitterTweetBot::API::Authorization::SecureCode).to(
          receive(:code_challenge).and_return('*' * 5)
        )
      end

      it 'return authorization information as Hash' do
        expect(authorization).to be_a(Hash)
        expect(authorization[:url]).to eq(
          URI('https://twitter.com/i/oauth2/authorize').tap do |uri|
            uri.query = URI.encode_www_form(
              {
                response_type: 'code',
                redirect_uri: params[:redirect_uri],
                client_id: params[:client_id],
                scope: params[:scopes].join(' '),
                code_challenge: '*' * 5,
                code_challenge_method: 'S256',
                state: '*' * 4
              }
            )
          end.to_s
        )
        expect(authorization[:code_verifier]).to eq('*' * 3)
        expect(authorization[:state]).to eq('*' * 4)

        expect(TwitterTweetBot::API::Authorization::SecureCode).to(
          have_received(:code_verifier)
            .with(no_args).once
        )
        expect(TwitterTweetBot::API::Authorization::SecureCode).to(
          have_received(:state)
            .with(no_args).once
        )
        expect(TwitterTweetBot::API::Authorization::SecureCode).to(
          have_received(:code_challenge)
            .with('*' * 3, 'S256').once
        )
      end
    end
  end
end
