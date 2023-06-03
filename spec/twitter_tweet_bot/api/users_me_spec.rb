RSpec.describe TwitterTweetBot::API::UsersMe do
  describe '::fetch' do
    subject { described_class.fetch(**params) }

    let(:params) do
      {
        access_token: Faker::Alphanumeric.alpha(number: 5),
        fields: {}
      }
    end
    let(:query) { URI.encode_www_form(params.slice(:fields)) }
    let(:response_json) { { data: { name: Faker::Internet.username } }.to_json }

    before do
      stub_get('https://api.twitter.com/2/users/me')
        .to_return(body: response_json)
    end

    it 'get current user\'s information' do
      is_expected.to eq(response_json)

      expect(
        a_get('https://api.twitter.com/2/users/me')
          .with(
            headers: {
              'Authorization' => "Bearer #{params[:access_token]}"
            }
          )
      ).to have_been_made.once
    end
  end
end
