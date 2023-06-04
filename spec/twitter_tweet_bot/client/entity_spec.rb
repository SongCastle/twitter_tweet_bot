RSpec.describe TwitterTweetBot::Client::Entity do
  let(:entity_klass) do
    Class.new.tap do |klass|
      klass.instance_exec(described_class) do |mod|
        prepend mod
      end
    end
  end

  describe '#authorize' do
    subject(:authorization) { entity_klass.new.authorize }

    let(:response_body) do
      {
        url: Faker::Internet.url,
        code_verifier: Faker::Alphanumeric.alpha(number: 5),
        state: Faker::Alphanumeric.alpha(number: 5)
      }
    end

    before do
      entity_klass.instance_exec(response_body) do |body|
        define_method(:authorize) { body }
      end
    end

    it 'wrap response as `Entity::Authorization`' do
      expect(authorization).to be_a(TwitterTweetBot::Entity::Authorization)
      expect(authorization.row).to be(response_body)
      expect(authorization.url).to eq(response_body[:url])
      expect(authorization.code_verifier).to eq(response_body[:code_verifier])
      expect(authorization.state).to eq(response_body[:state])
    end
  end

  describe '#fetch_token' do
    subject(:access_token) { entity_klass.new.fetch_token }

    let(:response_body) do
      {
        token_type: 'bearer',
        expires_in: 7200,
        scope: 'tweet.read tweet.write users.read offline.access',
        access_token: Faker::Alphanumeric.alpha(number: 5),
        refresh_token: Faker::Alphanumeric.alpha(number: 5)
      }
    end

    before do
      entity_klass.instance_exec(response_body) do |body|
        define_method(:fetch_token) { body.to_json }
      end
    end

    it 'wrap response as `Entity::Token`' do
      expect(access_token).to be_a(TwitterTweetBot::Entity::Token)
      expect(access_token.row).to eq(response_body)
      expect(access_token.token_type).to eq(response_body[:token_type])
      expect(access_token.expires_in).to eq(response_body[:expires_in])
      expect(access_token.scope).to eq(response_body[:scope])
      expect(access_token.access_token).to eq(response_body[:access_token])
      expect(access_token.refresh_token).to eq(response_body[:refresh_token])
    end
  end

  describe '#refresh_token' do
    subject(:refresh_token) { entity_klass.new.refresh_token }

    let(:response_body) do
      {
        token_type: 'bearer',
        expires_in: 7200,
        scope: 'tweet.read tweet.write users.read offline.access',
        access_token: Faker::Alphanumeric.alpha(number: 5),
        refresh_token: Faker::Alphanumeric.alpha(number: 5)
      }
    end

    before do
      entity_klass.instance_exec(response_body) do |body|
        define_method(:refresh_token) { body.to_json }
      end
    end

    it 'wrap response as `Entity::Token`' do
      expect(refresh_token).to be_a(TwitterTweetBot::Entity::Token)
      expect(refresh_token.row).to eq(response_body)
      expect(refresh_token.token_type).to eq(response_body[:token_type])
      expect(refresh_token.expires_in).to eq(response_body[:expires_in])
      expect(refresh_token.scope).to eq(response_body[:scope])
      expect(refresh_token.access_token).to eq(response_body[:access_token])
      expect(refresh_token.refresh_token).to eq(response_body[:refresh_token])
    end
  end

  describe '#post_tweet' do
    subject(:tweet) { entity_klass.new.post_tweet }

    let(:response_body) do
      {
        data: {
          id: Faker::Internet.uuid,
          edit_history_tweet_ids: [Faker::Internet.uuid],
          text: Faker::Lorem.word
        }
      }
    end

    before do
      entity_klass.instance_exec(response_body) do |body|
        define_method(:post_tweet) { body.to_json }
      end
    end

    it 'wrap response as `Entity::Tweet`' do
      expect(tweet).to be_a(TwitterTweetBot::Entity::Tweet)
      expect(tweet.row).to eq(response_body)
      expect(tweet.id).to eq(response_body[:data][:id])
      expect(tweet.edit_history_tweet_ids).to eq(response_body[:data][:edit_history_tweet_ids])
      expect(tweet.text).to eq(response_body[:data][:text])
    end
  end

  describe '#users_me' do
    subject(:users_me) { entity_klass.new.users_me }

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
      entity_klass.instance_exec(response_body) do |body|
        define_method(:users_me) { body.to_json }
      end
    end

    it 'wrap response as `Entity::User`' do
      expect(users_me).to be_a(TwitterTweetBot::Entity::User)
      expect(users_me.row).to eq(response_body)
      expect(users_me.id).to eq(response_body[:data][:id])
      expect(users_me.name).to eq(response_body[:data][:name])
      expect(users_me.username).to eq(response_body[:data][:username])
    end
  end
end
