RSpec.describe TwitterTweetBot::API::Tweet do
  describe '::post' do
    subject { described_class.post(**params) }

    let(:params) do
      {
        access_token: Faker::Alphanumeric.alpha(number: 5),
        text: Faker::Lorem.word
      }
    end
    let(:response_body) { { data: params.slice(:text) } }

    before do
      stub_post('https://api.twitter.com/2/tweets')
        .and_return_json(body: response_body)
    end

    it 'posts a tweet' do
      is_expected.to eq(response_body.to_json)

      expect(
        a_post('https://api.twitter.com/2/tweets')
          .with(
            body: params.slice(:text).to_json,
            headers: {
              'Authorization' => "Bearer #{params[:access_token]}",
              'Content-Type' => 'application/json'
            }
          )
      ).to have_been_made.once
    end
  end
end
