RSpec.describe TwitterTweetBot::API::AccessToken do
  describe '::fetch' do
    subject { described_class.fetch(**params) }

    let(:params) do
      {
        client_id: Faker::Alphanumeric.alpha(number: 5),
        client_secret: Faker::Alphanumeric.alpha(number: 5),
        redirect_uri: Faker::Internet.url,
        code: Faker::Alphanumeric.alpha(number: 5),
        code_verifier: Faker::Alphanumeric.alpha(number: 5)
      }
    end
    let(:response_body) { { access_token: '*' * 5 } }

    before do
      stub_post('https://api.twitter.com/2/oauth2/token')
        .and_return_json(body: response_body)
    end

    it 'fetches an access_token' do
      is_expected.to eq(response_body.to_json)

      expect(
        a_post('https://api.twitter.com/2/oauth2/token')
          .with(
            body: URI.encode_www_form(
              {
                grant_type: 'authorization_code',
                code: params[:code],
                code_verifier: params[:code_verifier],
                redirect_uri: params[:redirect_uri]
              }
            ),
            headers: {
              'Authorization' => format(
                'Basic %s',
                Base64.strict_encode64("#{params[:client_id]}:#{params[:client_secret]}")
              ),
              'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8'
            }
          )
      ).to have_been_made.once
    end
  end
end
