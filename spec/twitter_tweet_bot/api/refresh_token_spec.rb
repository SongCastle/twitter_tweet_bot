RSpec.describe TwitterTweetBot::API::RefreshToken do
  describe '::fetch' do
    subject { described_class.fetch(**params) }

    let(:params) do
      {
        client_id: Faker::Alphanumeric.alpha(number: 5),
        client_secret: Faker::Alphanumeric.alpha(number: 5),
        refresh_token: Faker::Alphanumeric.alpha(number: 5)
      }
    end
    let(:response_json) { { access_token: '*' * 5 }.to_json }

    before do
      stub_post('https://api.twitter.com/2/oauth2/token')
        .to_return(body: response_json)
    end

    it 'refresh an access_token' do
      is_expected.to eq(response_json)

      expect(
        a_post('https://api.twitter.com/2/oauth2/token')
          .with(
            body: URI.encode_www_form(
              {
                grant_type: 'refresh_token',
                refresh_token: params[:refresh_token],
                client_id: params[:client_id]
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
