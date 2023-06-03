RSpec.describe TwitterTweetBot::API::UsersMe do
  describe '::fetch' do
    subject { described_class.fetch(**params) }

    let(:params) do
      {
        access_token: Faker::Alphanumeric.alpha(number: 5),
        params: {}
      }
    end
    let(:response_body) { { data: { name: Faker::Internet.username } } }

    before do
      stub_get('https://api.twitter.com/2/users/me')
        .to_return_json(body: response_body)
    end

    it 'request current user\'s information' do
      is_expected.to eq(response_body.to_json)

      expect(
        a_get('https://api.twitter.com/2/users/me')
          .with(
            headers: {
              'Authorization' => "Bearer #{params[:access_token]}"
            }
          )
      ).to have_been_made.once
    end

    context 'when specified params' do
      let(:params) do
        {
          access_token: Faker::Alphanumeric.alpha(number: 5),
          params: {
            expansions: 'pinned_tweet_id',
            tweet_fields: 'attachments',
            user_fields: %w[created_at description]
          }
        }
      end

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
        reset_executed_requests!

        stub_get("https://api.twitter.com/2/users/me?#{query}")
          .to_return_json(body: response_body)
      end

      it 'request current user\'s information with fields' do
        is_expected.to eq(response_body.to_json)

        expect(
          a_get("https://api.twitter.com/2/users/me?#{query}")
            .with(
              headers: {
                'Authorization' => "Bearer #{params[:access_token]}"
              }
            )
        ).to have_been_made.once
      end
    end
  end
end
