RSpec.describe TwitterTweetBot do
  after { described_class.default_config = nil }

  shared_context 'with configured bot' do
    before do
      described_class.configure do |c|
        c.name = Faker::Internet.username
        c.client_id = Faker::Alphanumeric.alpha(number: 5)
        c.client_secret = Faker::Alphanumeric.alpha(number: 5)
        c.redirect_uri = Faker::Internet.url
        c.scopes = %w[tweet.read tweet.write users.read offline.access]
      end
    end
  end

  describe '::configure' do
    let(:params) do
      {
        name: Faker::Internet.username,
        client_id: Faker::Alphanumeric.alpha(number: 5),
        client_secret: Faker::Alphanumeric.alpha(number: 5),
        redirect_uri: Faker::Internet.url,
        scopes: %w[tweet.read tweet.write users.read offline.access]
      }
    end

    it 'sets a default configuration' do
      expect do
        described_class.configure do |c|
          c.name = params[:name]
          c.client_id = params[:client_id]
          c.client_secret = params[:client_secret]
          c.redirect_uri = params[:redirect_uri]
          c.scopes = params[:scopes]
        end
      end.to(
        change(described_class, :default_config)
          .from(be_nil).to(be_a(TwitterTweetBot::Configuration))
      )

      expect(described_class.default_config).to be_client_config(params)
    end
  end

  describe '::client' do
    let(:params) do
      {
        name: Faker::Internet.username,
        client_id: Faker::Alphanumeric.alpha(number: 5),
        client_secret: Faker::Alphanumeric.alpha(number: 5),
        redirect_uri: Faker::Internet.url,
        scopes: %w[tweet.read tweet.write users.read offline.access]
      }
    end

    context 'without arguments' do
      subject(:client) { described_class.client }

      context 'when an default configuration is initialized' do
        before do
          described_class.configure do |c|
            c.name = params[:name]
            c.client_id = params[:client_id]
            c.client_secret = params[:client_secret]
            c.redirect_uri = params[:redirect_uri]
            c.scopes = params[:scopes]
          end
        end

        it 'returns a initialized `Client` by a default configuration' do
          expect(client).to be_a(described_class::Client)
          expect(client.send(:config)).to be_client_config(params)
        end
      end

      context 'when a default configuration is NOT initialized' do
        it 'raises `NoConfigurationError`' do # rubocop:disable RSpec/NoExpectationExample
          is_expect_caused.to(
            raise_error(described_class::NoConfigurationError)
          )
        end
      end
    end

    context 'with arguments' do
      subject(:client) do
        described_class.client(
          described_class::Configuration.new(**params)
        )
      end

      it 'returns a initialized `Client` by a passed configuration' do
        expect(client).to be_a(described_class::Client)
        expect(client.send(:config)).to be_client_config(params)
      end
    end
  end

  describe '::authorize' do
    include_context 'with configured bot'

    let(:mock_client) do
      Module.new do
        def self.authorize
          '*'
        end
      end
    end

    before do
      allow(described_class).to(
        receive(:client).and_return(mock_client)
      )
      allow(mock_client).to(
        receive(:authorize).and_call_original
      )
    end

    it 'authorizes with the default client' do
      expect(described_class.authorize).to eq('*')
      expect(mock_client).to have_received(:authorize).once
    end
  end

  describe '::fetch_token' do
    include_context 'with configured bot'

    let(:mock_client) do
      Module.new do
        def self.fetch_token
          '*'
        end
      end
    end

    before do
      allow(described_class).to(
        receive(:client).and_return(mock_client)
      )
      allow(mock_client).to(
        receive(:fetch_token).and_call_original
      )
    end

    it 'fetches an access token with the default client' do
      expect(described_class.fetch_token).to eq('*')
      expect(mock_client).to have_received(:fetch_token).once
    end
  end

  describe '::refresh_token' do
    include_context 'with configured bot'

    let(:mock_client) do
      Module.new do
        def self.refresh_token
          '*'
        end
      end
    end

    before do
      allow(described_class).to(
        receive(:client).and_return(mock_client)
      )
      allow(mock_client).to(
        receive(:refresh_token).and_call_original
      )
    end

    it 'refreshes an access token with the default client' do
      expect(described_class.refresh_token).to eq('*')
      expect(mock_client).to have_received(:refresh_token).once
    end
  end

  describe '::post_tweet' do
    include_context 'with configured bot'

    let(:mock_client) do
      Module.new do
        def self.post_tweet
          '*'
        end
      end
    end

    before do
      allow(described_class).to(
        receive(:client).and_return(mock_client)
      )
      allow(mock_client).to(
        receive(:post_tweet).and_call_original
      )
    end

    it 'posts a tweet with the default client' do
      expect(described_class.post_tweet).to eq('*')
      expect(mock_client).to have_received(:post_tweet).once
    end
  end

  describe '::users_me' do
    include_context 'with configured bot'

    let(:mock_client) do
      Module.new do
        def self.users_me
          '*'
        end
      end
    end

    before do
      allow(described_class).to(
        receive(:client).and_return(mock_client)
      )
      allow(mock_client).to(
        receive(:users_me).and_call_original
      )
    end

    it 'fetch current user information with the default client' do
      expect(described_class.users_me).to eq('*')
      expect(mock_client).to have_received(:users_me).once
    end
  end
end
