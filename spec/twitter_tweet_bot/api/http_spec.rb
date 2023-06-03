RSpec.describe TwitterTweetBot::API::HTTP do
  let(:http_klass) do
    Class.new.tap do |klass|
      klass.instance_exec(described_class) do |mod|
        include mod
      end
    end
  end

  describe '#request' do
    let(:uri) { Faker::Internet.url }
    let(:body) { { foo: :bar } }

    context 'when GET request' do
      subject do
        http_klass.new.request(
          :get, uri, body, { 'X-Dummy' => 'dummy' }
        )
      end

      let(:uri_with_query) { "#{uri}?#{URI.encode_www_form(body)}" }

      before do
        stub_get(uri_with_query)
          .to_return_json(body: { piyo: :piyopiyo })
      end

      it 'executes a GET request' do
        is_expected.to eq({ piyo: :piyopiyo }.to_json)

        expect(
          a_get(uri_with_query)
            .with(headers: { 'X-Dummy' => 'dummy' })
        ).to have_been_made.once
      end
    end

    context 'when POST (Form) request' do
      subject do
        http_klass.new.request(
          :post_form, uri, body, { 'X-Dummy' => 'dummy' }
        )
      end

      before do
        stub_post(uri)
          .to_return_json(body: { piyo: :piyopiyo })
      end

      it 'executes a POST (Form) request' do
        is_expected.to eq({ piyo: :piyopiyo }.to_json)

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

    context 'when POST (JSON) request' do
      subject do
        http_klass.new.request(
          :post_json, uri, body, { 'X-Dummy' => 'dummy' }
        )
      end

      before do
        stub_post(uri)
          .to_return_json(body: { piyo: :piyopiyo })
      end

      it 'executes a POST (JSON) request' do
        is_expected.to eq({ piyo: :piyopiyo }.to_json)

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

    context 'when request failed' do
      subject do
        http_klass.new.request(
          :get, uri, body, { 'X-Dummy' => 'dummy' }
        )
      end

      let(:uri_with_query) { "#{uri}?#{URI.encode_www_form(body)}" }
      let(:response_body) { { error: 'invalid_request' } }

      before do
        stub_get(uri_with_query)
          .to_return_json(status: 400, body: response_body)
      end

      it 'raises `Error::RequestFaild`' do
        is_expect_caused.to(
          raise_error(described_class::Error::RequestFaild) do |error|
            expect(error.message).to eq("400\n#{response_body.to_json}")
          end
        )

        expect(
          a_get(uri_with_query)
            .with(headers: { 'X-Dummy' => 'dummy' })
        ).to have_been_made.once
      end
    end
  end
end
