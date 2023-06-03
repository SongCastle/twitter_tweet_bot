RSpec.describe TwitterTweetBot::API::HTTP::Base do
  let(:http_klass) do
    Class.new.tap do |klass|
      klass.instance_exec(described_class) do |mod|
        include mod
      end
    end
  end

  describe '#perform_request' do
    subject(:http) do
      http_klass.new.perform_request(
        URI(uri),
        Net::HTTP::Get.new(URI(uri), { 'X-Dummy' => 'dummy' })
      )
    end

    let(:uri) { Faker::Internet.url }
    let(:response_body) { { foo: :bar } }

    before { stub_get(uri).and_return_json(body: response_body) }

    it 'executes a request' do
      expect(http.code).to eq('200')
      expect(http.body).to eq(response_body.to_json)

      expect(
        a_get(uri).with(headers: { 'X-Dummy' => 'dummy' })
      ).to have_been_made.once
    end
  end
end
