RSpec.describe TwitterTweetBot::API::HTTP::Get do
  let(:http_klass) do
    Class.new.tap do |klass|
      klass.instance_exec(described_class) do |mod|
        include mod
      end
    end
  end

  describe '#request_get' do
    let(:uri) { Faker::Internet.url }
    let(:uri_with_query) { "#{uri}?#{URI.encode_www_form(query)}" }
    let(:query) { { foo: :bar } }

    before do
      stub_get(uri_with_query)
        .to_return_json(body: { piyo: :piyopiyo })
    end

    context 'when headers are given' do
      subject(:http) do
        http_klass.new.request_get(
          uri, query, { 'X-Dummy' => 'dummy' }
        )
      end

      it 'executes a request with given headers' do
        expect(http.code).to eq('200')
        expect(http.body).to eq({ piyo: :piyopiyo }.to_json)

        expect(
          a_get(uri_with_query)
            .with(headers: { 'X-Dummy' => 'dummy' })
        ).to have_been_made.once
      end
    end

    context 'when headers are NOT given' do
      subject(:http) do
        http_klass.new.request_get(uri, query)
      end

      it 'executes a request' do
        expect(http.code).to eq('200')
        expect(http.body).to eq({ piyo: :piyopiyo }.to_json)

        expect(a_get(uri_with_query)).to have_been_made.once
      end
    end
  end
end
