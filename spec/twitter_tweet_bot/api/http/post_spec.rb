RSpec.describe TwitterTweetBot::API::HTTP::Post do
  let(:http_klass) do
    Class.new.tap do |klass|
      klass.instance_exec(described_class) do |mod|
        include mod
      end
    end
  end

  describe '#request_post_form' do
    let(:uri) { Faker::Internet.url }
    let(:body) { { foo: :bar } }

    before do
      stub_post(uri)
        .to_return(body: { piyo: :piyopiyo }.to_json)
    end

    context 'when headers are given' do
      subject(:http) do
        http_klass.new.request_post_form(
          uri, body, { 'X-Dummy' => 'dummy' }
        )
      end

      it 'executes a request with given headers' do
        expect(http.code).to eq('200')
        expect(http.body).to eq({ piyo: :piyopiyo }.to_json)

        expect(
          a_post(uri)
            .with(
              body: URI.encode_www_form(body),
              headers: {
                'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8',
                'X-Dummy' => 'dummy'
              }
            )
        ).to have_been_made.once
      end
    end

    context 'when headers are NOT given' do
      subject(:http) do
        http_klass.new.request_post_form(uri, body)
      end

      it 'executes a request' do
        expect(http.code).to eq('200')
        expect(http.body).to eq({ piyo: :piyopiyo }.to_json)

        expect(
          a_post(uri)
            .with(
              body: URI.encode_www_form(body),
              headers: {
                'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8'
              }
            )
        ).to have_been_made.once
      end
    end
  end

  describe '#request_post_json' do
    let(:uri) { Faker::Internet.url }
    let(:body) { { foo: :bar } }

    before do
      stub_post(uri)
        .to_return(body: { piyo: :piyopiyo }.to_json)
    end

    context 'when headers are given' do
      subject(:http) do
        http_klass.new.request_post_json(
          uri, body, { 'X-Dummy' => 'dummy' }
        )
      end

      it 'executes a request with given headers' do
        expect(http.code).to eq('200')
        expect(http.body).to eq({ piyo: :piyopiyo }.to_json)

        expect(
          a_post(uri)
            .with(
              body: body.to_json,
              headers: {
                'Content-Type' => 'application/json',
                'X-Dummy' => 'dummy'
              }
            )
        ).to have_been_made.once
      end
    end

    context 'when headers are NOT given' do
      subject(:http) do
        http_klass.new.request_post_json(uri, body)
      end

      it 'executes a request' do
        expect(http.code).to eq('200')
        expect(http.body).to eq({ piyo: :piyopiyo }.to_json)

        expect(
          a_post(uri)
            .with(
              body: body.to_json,
              headers: { 'Content-Type' => 'application/json' }
            )
        ).to have_been_made.once
      end
    end
  end
end
