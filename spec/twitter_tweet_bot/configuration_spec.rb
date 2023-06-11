RSpec.describe TwitterTweetBot::Configuration do
  describe '#initialize' do
    context 'without arguments' do
      subject(:config) { described_class.new }

      it 'initializes a configuration as default' do
        is_expected.to be_client_config(
          {
            name: nil,
            client_id: nil,
            client_secret: nil,
            redirect_uri: nil,
            scopes: []
          }
        )
      end
    end

    context 'with arguments' do
      subject { described_class.new(**params) }

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
        is_expected.to be_client_config(params)
      end
    end

    context 'with a block' do
      subject do
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
        is_expected.to be_client_config(params)
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
