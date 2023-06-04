RSpec.describe TwitterTweetBot::Client do
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
      subject(:authorization) do
        described_class.new(config).authorize
      end

      it 'requests `API::Authorization`' do
        expect(authorization).to be_a(TwitterTweetBot::Entity::Authorization)
        expect(authorization.row).to be(data)
        expect(authorization.url).to eq(data[:url])
        expect(authorization.code_verifier).to eq(data[:code_verifier])
        expect(authorization.state).to eq(data[:state])

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
      subject(:authorization) do
        described_class.new(config).authorize(
          data[:code_verifier],
          'S256',
          data[:state]
        )
      end

      it 'requests `API::Authorization`' do
        expect(authorization).to be_a(TwitterTweetBot::Entity::Authorization)
        expect(authorization.row).to be(data)
        expect(authorization.url).to eq(data[:url])
        expect(authorization.code_verifier).to eq(data[:code_verifier])
        expect(authorization.state).to eq(data[:state])

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
    subject(:access_token) do
      described_class.new(config).fetch_token(
        params[:code], params[:code_verifier]
      )
    end

    let(:params) do
      {
        code: Faker::Alphanumeric.alpha(number: 5),
        code_verifier: Faker::Alphanumeric.alpha(number: 5)
      }
    end
    let(:response_body) do
      {
        token_type: 'bearer',
        expires_in: 7200,
        scope: config[:scopes].join(' '),
        access_token: Faker::Alphanumeric.alpha(number: 5),
        refresh_token: Faker::Alphanumeric.alpha(number: 5)
      }
    end

    before do
      allow(TwitterTweetBot::API::AccessToken).to(
        receive(:fetch)
          .and_return(response_body.to_json)
      )
    end

    it 'requests `API::AccessToken`' do
      expect(access_token).to be_a(TwitterTweetBot::Entity::Token)
      expect(access_token.row).to eq(response_body)
      expect(access_token.token_type).to eq(response_body[:token_type])
      expect(access_token.expires_in).to eq(response_body[:expires_in])
      expect(access_token.scope).to eq(response_body[:scope])
      expect(access_token.access_token).to eq(response_body[:access_token])
      expect(access_token.refresh_token).to eq(response_body[:refresh_token])

      expect(TwitterTweetBot::API::AccessToken).to(
        have_received(:fetch)
          .with(**config, **params)
          .once
      )
    end
  end

  describe '#refresh_token' do
    subject(:refresh_token) do
      described_class.new(config).refresh_token(token)
    end

    let(:token) { Faker::Alphanumeric.alpha(number: 5) }
    let(:response_body) do
      {
        token_type: 'bearer',
        expires_in: 7200,
        scope: config[:scopes].join(' '),
        access_token: Faker::Alphanumeric.alpha(number: 5),
        refresh_token: Faker::Alphanumeric.alpha(number: 5)
      }
    end

    before do
      allow(TwitterTweetBot::API::RefreshToken).to(
        receive(:fetch)
          .and_return(response_body.to_json)
      )
    end

    it 'requests `API::RefreshToken`' do
      expect(refresh_token).to be_a(TwitterTweetBot::Entity::Token)
      expect(refresh_token.row).to eq(response_body)
      expect(refresh_token.token_type).to eq(response_body[:token_type])
      expect(refresh_token.expires_in).to eq(response_body[:expires_in])
      expect(refresh_token.scope).to eq(response_body[:scope])
      expect(refresh_token.access_token).to eq(response_body[:access_token])
      expect(refresh_token.refresh_token).to eq(response_body[:refresh_token])

      expect(TwitterTweetBot::API::RefreshToken).to(
        have_received(:fetch)
          .with(**config, refresh_token: token)
          .once
      )
    end
  end

  describe '#post_tweet' do
    subject(:tweet) do
      described_class.new(config).post_tweet(
        params[:access_token], params[:text]
      )
    end

    let(:params) do
      {
        access_token: Faker::Alphanumeric.alpha(number: 5),
        text: Faker::Lorem.word
      }
    end
    let(:response_body) do
      {
        data: {
          id: Faker::Internet.uuid,
          edit_history_tweet_ids: [Faker::Internet.uuid],
          text: params[:text]
        }
      }
    end

    before do
      allow(TwitterTweetBot::API::Tweet).to(
        receive(:post)
          .and_return(response_body.to_json)
      )
    end

    it 'requests `API::Tweet`' do
      expect(tweet).to be_a(TwitterTweetBot::Entity::Tweet)
      expect(tweet.row).to eq(response_body)
      expect(tweet.id).to eq(response_body[:data][:id])
      expect(tweet.edit_history_tweet_ids).to eq(response_body[:data][:edit_history_tweet_ids])
      expect(tweet.text).to eq(response_body[:data][:text])

      expect(TwitterTweetBot::API::Tweet).to(
        have_received(:post)
          .with(**config, **params)
          .once
      )
    end
  end

  describe '#users_me' do
    let(:response_body) do
      {
        data: {
          id: Faker::Internet.uuid,
          name: Faker::Internet.username,
          username: Faker::Name.first_name
        }
      }
    end

    before do
      allow(TwitterTweetBot::API::UsersMe).to(
        receive(:fetch)
          .and_return(response_body.to_json)
      )
    end

    context 'without arguments' do
      subject(:users_me) do
        described_class.new(config).users_me(access_token)
      end

      let(:access_token) { Faker::Alphanumeric.alpha(number: 5) }

      it 'requests `API::UsersMe`' do
        expect(users_me).to be_a(TwitterTweetBot::Entity::User)
        expect(users_me.row).to eq(response_body)
        expect(users_me.id).to eq(response_body[:data][:id])
        expect(users_me.name).to eq(response_body[:data][:name])
        expect(users_me.username).to eq(response_body[:data][:username])

        expect(TwitterTweetBot::API::UsersMe).to(
          have_received(:fetch)
            .with(**config, access_token: access_token, params: {})
            .once
        )
      end
    end

    context 'with arguments' do
      subject(:users_me) do
        described_class.new(config).users_me(
          params[:access_token], params[:params]
        )
      end

      let(:params) do
        {
          access_token: Faker::Alphanumeric.alpha(number: 5),
          params: { user_fields: 'created_at' }
        }
      end

      it 'requests `API::UsersMe`' do
        expect(users_me).to be_a(TwitterTweetBot::Entity::User)
        expect(users_me.row).to eq(response_body)
        expect(users_me.id).to eq(response_body[:data][:id])
        expect(users_me.name).to eq(response_body[:data][:name])
        expect(users_me.username).to eq(response_body[:data][:username])

        expect(TwitterTweetBot::API::UsersMe).to(
          have_received(:fetch)
            .with(**config, **params)
            .once
        )
      end
    end
  end
end
