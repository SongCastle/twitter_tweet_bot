RSpec.describe TwitterTweetBot::API::UsersMe do
  describe '::fetch' do
    context 'without params' do
      subject { described_class.fetch(access_token: access_token) }

      let(:access_token) { Faker::Alphanumeric.alpha(number: 5) }
      let(:response_body) { { data: { name: Faker::Internet.username } } }

      before do
        stub_get('https://api.twitter.com/2/users/me')
          .and_return_json(body: response_body)
      end

      it 'request current users information' do
        is_expected.to eq(response_body.to_json)

        expect(
          a_get('https://api.twitter.com/2/users/me')
            .with(
              headers: {
                'Authorization' => "Bearer #{access_token}"
              }
            )
        ).to have_been_made.once
      end
    end

    context 'with params' do
      subject do
        described_class.fetch(access_token: access_token) do |params|
          params.expansions = 'pinned_tweet_id'
          params.tweet_fields = 'attachments'
          params.user_fields = %w[created_at description]
        end
      end

      let(:access_token) { Faker::Alphanumeric.alpha(number: 5) }
      let(:query) do
        URI.encode_www_form(
          {
            'expansions' => 'pinned_tweet_id',
            'tweet.fields' => 'attachments',
            'user.fields' => %w[created_at description].join(',')
          }
        )
      end
      let(:response_body) do
        {
          data: {
            name: Faker::Internet.username,
            created_at: Faker::Time.backward(days: 30).to_s
          }
        }
      end

      before do
        stub_get("https://api.twitter.com/2/users/me?#{query}")
          .and_return_json(body: response_body)
      end

      it 'request current user information with fields' do
        is_expected.to eq(response_body.to_json)

        expect(
          a_get("https://api.twitter.com/2/users/me?#{query}")
            .with(
              headers: {
                'Authorization' => "Bearer #{access_token}"
              }
            )
        ).to have_been_made.once
      end
    end
  end
end
