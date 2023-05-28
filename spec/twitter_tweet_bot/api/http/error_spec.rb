RSpec.describe TwitterTweetBot::API::HTTP::Error do
  describe 'RequestFaild' do
    describe '#message' do
      subject do
        described_class::RequestFaild
          .new(400, body)
          .message
      end

      let(:body) { { error: 'invalid_request' }.to_json }

      it 'returns an error message' do
        is_expected.to eq("400\n#{body}")
      end
    end
  end

  describe '#request_error!' do
    subject do
      http_klass
        .new.request_error!(400, body)
    end

    let(:http_klass) do
      Class.new.tap do |klass|
        klass.instance_exec(described_class) do |mod|
          include mod
        end
      end
    end

    let(:body) { { error: 'invalid_request' }.to_json }

    it 'raises `RequestFaild`' do
      is_expect_caused.to(
        raise_error(described_class::RequestFaild) do |error|
          expect(error.message).to eq("400\n#{body}")
        end
      )
    end
  end
end
