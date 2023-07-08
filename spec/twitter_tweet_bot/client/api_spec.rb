RSpec.describe TwitterTweetBot::Client::API do
  let(:api_klass) do
    Class.new.tap do |klass|
      klass.instance_exec(described_class) do |mod|
        include mod

        attr_reader :config

        define_method(:initialize) do |config|
          @config = config
        end
      end
    end
  end
  let(:config) do
    {
      name: Faker::Internet.username,
      client_id: Faker::Alphanumeric.alpha(number: 5),
      client_secret: Faker::Alphanumeric.alpha(number: 5),
      redirect_uri: Faker::Internet.url,
      scopes: %w[tweet.read tweet.write users.read offline.access]
    }
  end

  describe '#authorize' do
    let(:data) do
      {
        url: Faker::Internet.url,
        code_verifier: Faker::Alphanumeric.alpha(number: 5),
        state: Faker::Alphanumeric.alpha(number: 5)
      }
    end

    before do
      allow(TwitterTweetBot::API::Authorization).to(
        receive(:authorize)
          .and_return(data)
      )
    end

    context 'without arguments' do
      subject { api_klass.new(config).authorize }

      it 'calls `API::Authorization#authorize`' do
        is_expected.to eq(data)

        expect(TwitterTweetBot::API::Authorization).to(
          have_received(:authorize)
            .with(
              **config,
              code_verifier: nil,
              code_challenge_method: nil,
              state: nil
            )
            .once
        )
      end
    end

    context 'with arguments' do
      subject do
        api_klass.new(config).authorize(
          data[:code_verifier],
          'S256',
          data[:state]
        )
      end

      it 'calls `API::Authorization#authorize`' do
        is_expected.to eq(data)

        expect(TwitterTweetBot::API::Authorization).to(
          have_received(:authorize)
            .with(
              **config,
              code_verifier: data[:code_verifier],
              code_challenge_method: 'S256',
              state: data[:state]
            )
            .once
        )
      end
    end
  end

  describe '#fetch_token' do
    subject do
      api_klass.new(config).fetch_token(
        params[:code], params[:code_verifier]
      )
    end

    let(:params) do
      {
        code: Faker::Alphanumeric.alpha(number: 5),
        code_verifier: Faker::Alphanumeric.alpha(number: 5)
      }
    end
    let(:response_json) do
      {
        token_type: 'bearer',
        expires_in: 7200,
        scope: config[:scopes].join(' '),
        access_token: Faker::Alphanumeric.alpha(number: 5),
        refresh_token: Faker::Alphanumeric.alpha(number: 5)
      }.to_json
    end

    before do
      allow(TwitterTweetBot::API::AccessToken).to(
        receive(:fetch)
          .and_return(response_json)
      )
    end

    it 'calls `API::AccessToken#fetch`' do
      is_expected.to eq(response_json)

      expect(TwitterTweetBot::API::AccessToken).to(
        have_received(:fetch)
          .with(**config, **params)
          .once
      )
    end
  end

  describe '#refresh_token' do
    subject do
      api_klass.new(config).refresh_token(
        refresh_token
      )
    end

    let(:refresh_token) { Faker::Alphanumeric.alpha(number: 5) }
    let(:response_json) do
      {
        token_type: 'bearer',
        expires_in: 7200,
        scope: config[:scopes].join(' '),
        access_token: Faker::Alphanumeric.alpha(number: 5),
        refresh_token: Faker::Alphanumeric.alpha(number: 5)
      }.to_json
    end

    before do
      allow(TwitterTweetBot::API::RefreshToken).to(
        receive(:fetch)
          .and_return(response_json)
      )
    end

    it 'calls `API::RefreshToken#fetch`' do
      is_expected.to eq(response_json)

      expect(TwitterTweetBot::API::RefreshToken).to(
        have_received(:fetch)
          .with(**config, refresh_token: refresh_token)
          .once
      )
    end
  end

  describe '#post_tweet' do
    let(:access_token) { Faker::Alphanumeric.alpha(number: 5) }
    let(:response_json) do
      {
        data: {
          id: Faker::Internet.uuid,
          edit_history_tweet_ids: [Faker::Internet.uuid],
          text: request_body[:text]
        }
      }.to_json
    end

    before do
      allow(TwitterTweetBot::API::Tweet).to(
        receive(:post)
          .and_return(response_json)
      )
    end

    context 'without block' do
      subject do
        api_klass.new(config).post_tweet(
          access_token, request_body[:text]
        )
      end

      let(:request_body) do
        { text: Faker::Lorem.word }
      end

      it 'calls `API::Tweet#post`' do
        is_expected.to eq(response_json)

        expect(TwitterTweetBot::API::Tweet).to(
          have_received(:post)
            .with(
              **config,
              access_token: access_token,
              text: request_body[:text]
            )
            .once
        )
      end
    end

    context 'with block' do
      subject do
        api_klass.new(config).post_tweet(access_token, nil) do |params|
          params.for_super_followers_only = request_body[:for_super_followers_only]
          params.media = request_body[:media]
        end
      end

      let(:request_body) do
        {
          for_super_followers_only: Faker::Boolean.boolean,
          media: {
            media_ids: [Faker::Internet.uuid],
            tagged_user_ids: [Faker::Internet.uuid]
          }
        }
      end

      it 'calls `API::Tweet#post`' do
        is_expected.to eq(response_json)

        expect(TwitterTweetBot::API::Tweet).to(
          have_received(:post) do |_, &block|
            expect(
              Struct.new(:for_super_followers_only, :media).new.tap(&block).to_h
            ).to eq(request_body)
          end.with(**config, access_token: access_token, text: nil).once
        )
      end
    end
  end

  describe '#users_me' do
    let(:response_json) do
      {
        data: {
          id: Faker::Internet.uuid,
          name: Faker::Internet.username,
          username: Faker::Name.first_name
        }
      }.to_json
    end

    before do
      allow(TwitterTweetBot::API::UsersMe).to(
        receive(:fetch)
          .and_return(response_json)
      )
    end

    context 'without block' do
      subject do
        api_klass.new(config).users_me(access_token)
      end

      let(:access_token) { Faker::Alphanumeric.alpha(number: 5) }

      it 'calls `API::UsersMe#fetch`' do
        is_expected.to eq(response_json)

        expect(TwitterTweetBot::API::UsersMe).to(
          have_received(:fetch)
            .with(**config, access_token: access_token)
            .once
        )
      end
    end

    context 'with block' do
      subject do
        api_klass.new(config).users_me(access_token) do |params|
          params.user_fields = 'created_at'
        end
      end

      let(:access_token) { Faker::Alphanumeric.alpha(number: 5) }

      it 'calls `API::UsersMe#fetch`' do
        is_expected.to eq(response_json)

        expect(TwitterTweetBot::API::UsersMe).to(
          have_received(:fetch) do |_, &block|
            expect(
              Struct.new(:user_fields).new.tap(&block).to_h
            ).to eq({ user_fields: 'created_at' })
          end.with(**config, access_token: access_token).once
        )
      end
    end
  end
end
