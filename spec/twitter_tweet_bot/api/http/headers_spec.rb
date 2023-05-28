RSpec.describe TwitterTweetBot::API::HTTP::Headers do
  let(:http_klass) do
    Class.new.tap do |klass|
      klass.instance_exec(described_class) do |mod|
        include mod
      end
    end
  end

  describe '#basic_authorization_header' do
    subject do
      http_klass.new.basic_authorization_header(user, password)
    end

    let(:user) { Faker::Internet.username }
    let(:password) { Faker::Internet.password }

    it 'returns a header for basic authorization' do
      is_expected.to eq(
        {
          authorization: \
            format('Basic %s', Base64.strict_encode64("#{user}:#{password}"))
        }
      )
    end
  end

  describe '#bearer_authorization_header' do
    subject do
      http_klass.new.bearer_authorization_header(credentials)
    end

    let(:credentials) { Faker::Alphanumeric.alpha(number: 5) }

    it 'returns a header for bearer authorization' do
      is_expected.to eq({ authorization: "Bearer #{credentials}" })
    end
  end
end
