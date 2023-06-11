RSpec.describe TwitterTweetBot::Configuration do
  describe '#initialize' do
    context 'without arguments' do
      subject(:config) { described_class.new }

      it 'initializes a configuration as default' do
        expect(config.name).to be_nil
        expect(config.client_id).to be_nil
        expect(config.client_secret).to be_nil
        expect(config.redirect_uri).to be_nil
        expect(config.scopes).to eq([])
      end
    end

    context 'with arguments' do
      subject(:config) { described_class.new(**params) }

      let(:params) do
        {
          name: Faker::Internet.username,
          client_id: Faker::Alphanumeric.alpha(number: 5),
          client_secret: Faker::Alphanumeric.alpha(number: 5),
          redirect_uri: Faker::Internet.url,
          scopes: %w[tweet.read tweet.write users.read offline.access]
        }
      end

      it 'sets a configuration from arguments' do
        expect(config.name).to eq(params[:name])
        expect(config.client_id).to eq(params[:client_id])
        expect(config.client_secret).to eq(params[:client_secret])
        expect(config.redirect_uri).to eq(params[:redirect_uri])
        expect(config.scopes).to eq(params[:scopes])
      end
    end

    context 'with a block' do
      subject(:config) do
        described_class.new do |c|
          c.name = params[:name]
          c.client_id = params[:client_id]
          c.client_secret = params[:client_secret]
          c.redirect_uri = params[:redirect_uri]
          c.scopes = params[:scopes]
        end
      end

      let(:params) do
        {
          name: Faker::Internet.username,
          client_id: Faker::Alphanumeric.alpha(number: 5),
          client_secret: Faker::Alphanumeric.alpha(number: 5),
          redirect_uri: Faker::Internet.url,
          scopes: %w[tweet.read tweet.write users.read offline.access]
        }
      end

      it 'sets a configuration with a block' do
        expect(config.name).to eq(params[:name])
        expect(config.client_id).to eq(params[:client_id])
        expect(config.client_secret).to eq(params[:client_secret])
        expect(config.redirect_uri).to eq(params[:redirect_uri])
        expect(config.scopes).to eq(params[:scopes])
      end
    end
  end

  describe '#to_hash' do
    subject { described_class.new(**params).to_hash }

    let(:params) do
      {
        name: Faker::Internet.username,
        client_id: Faker::Alphanumeric.alpha(number: 5),
        client_secret: Faker::Alphanumeric.alpha(number: 5),
        redirect_uri: Faker::Internet.url,
        scopes: %w[tweet.read tweet.write users.read offline.access]
      }
    end

    it 'returns a configuration as hash' do
      is_expected.to eq(params)
    end
  end
end
