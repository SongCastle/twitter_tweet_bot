RSpec.describe TwitterTweetBot::API::Tweet do
  describe '::post' do
    let(:access_token) { Faker::Alphanumeric.alpha(number: 5) }
    let(:response_body) do
      { data: { text: request_body[:text] } }
    end

    before do
      stub_post('https://api.twitter.com/2/tweets')
        .and_return_json(body: response_body)
    end

    context 'without block' do
      subject do
        described_class.post(
          access_token: access_token, text: request_body[:text]
        )
      end

      let(:request_body) do
        { text: Faker::Lorem.word }
      end

      it 'posts a tweet' do
        is_expected.to eq(response_body.to_json)

        expect(
          a_post('https://api.twitter.com/2/tweets')
            .with(
              body: request_body.to_json,
              headers: {
                'Authorization' => "Bearer #{access_token}",
                'Content-Type' => 'application/json'
              }
            )
        ).to have_been_made.once
      end
    end

    context 'with block' do
      subject do
        described_class.post(
          access_token: access_token, text: request_body[:text]
        ) do |params|
          params.quote_tweet_id = request_body[:quote_tweet_id]
          params.geo = request_body[:geo]
        end
      end

      let(:request_body) do
        {
          text: Faker::Lorem.word,
          quote_tweet_id: Faker::Internet.uuid,
          geo: {
            place_id: Faker::Internet.uuid
          }
        }
      end

      it 'posts a tweet' do
        is_expected.to eq(response_body.to_json)

        expect(
          a_post('https://api.twitter.com/2/tweets')
            .with(
              body: request_body.to_json,
              headers: {
                'Authorization' => "Bearer #{access_token}",
                'Content-Type' => 'application/json'
              }
            )
        ).to have_been_made.once
      end
    end
  end
end
