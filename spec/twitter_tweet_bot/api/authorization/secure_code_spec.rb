RSpec.describe TwitterTweetBot::API::Authorization::SecureCode do
  describe '::code_verifier' do
    context 'when code_verifier\'s length is given' do
      subject(:code_verifier) { described_class.code_verifier(32) }

      it 'returns an encoded string by base64' do
        expect(code_verifier).to be_a(String)
        expect(code_verifier).to eq(
          Base64.urlsafe_encode64(Base64.urlsafe_decode64(code_verifier))
        )
        expect(code_verifier.size).to eq(32)
        expect(code_verifier.encoding).to eq(Encoding::UTF_8)
      end
    end

    context 'when code_verifier\'s length is NOT given' do
      subject(:code_verifier) { described_class.code_verifier }

      it 'returns an encoded string by base64 (with default length)' do
        expect(code_verifier).to be_a(String)
        expect(code_verifier).to eq(
          Base64.urlsafe_encode64(Base64.urlsafe_decode64(code_verifier))
        )
        expect(code_verifier.size).to eq(64)
        expect(code_verifier.encoding).to eq(Encoding::UTF_8)
      end
    end
  end

  describe '::state' do
    context 'when state\'s length is given' do
      subject(:state) { described_class.state(16) }

      it 'returns an encoded string by base64' do
        expect(state).to be_a(String)
        expect(state).to eq(
          Base64.urlsafe_encode64(Base64.urlsafe_decode64(state))
        )
        expect(state.size).to eq(16)
        expect(state.encoding).to eq(Encoding::UTF_8)
      end
    end

    context 'when state\'s length is NOT given' do
      subject(:state) { described_class.state }

      it 'returns an encoded string by base64 (with default length)' do
        expect(state).to be_a(String)
        expect(state).to eq(
          Base64.urlsafe_encode64(Base64.urlsafe_decode64(state))
        )
        expect(state.size).to eq(32)
        expect(state.encoding).to eq(Encoding::UTF_8)
      end
    end
  end

  describe '::code_challenge' do
    shared_examples 'S256' do
      let(:code_verifier) { Faker::Alphanumeric.alpha(number: 5) }

      before do
        allow(OpenSSL::Digest::SHA256).to(
          receive(:digest).and_return('*' * 5)
        )
      end

      it 'returns a base64 encoded string that is hashed by \'S256\'' do
        expect(code_challenge).to be_a(String)
        expect(code_challenge).to eq(
          Base64.urlsafe_encode64('*' * 5, padding: false)
        )
        expect(code_challenge.encoding).to eq(Encoding::UTF_8)

        expect(OpenSSL::Digest::SHA256).to(
          have_received(:digest).with(code_verifier).once
        )
      end
    end

    context 'when challenge_method is \'S256\'' do
      subject(:code_challenge) do
        described_class.code_challenge(code_verifier, 'S256')
      end

      include_examples 'S256'
    end

    context 'when challenge_method is NOT \'S256\'' do
      subject(:code_challenge) do
        described_class.code_challenge(code_verifier, 'plain')
      end

      let(:code_verifier) { Faker::Alphanumeric.alpha(number: 5) }

      it 'returns an encoded string by base64' do
        expect(code_challenge).to be_a(String)
        expect(code_challenge).to eq(
          Base64.urlsafe_encode64(code_verifier, padding: false)
        )
        expect(code_challenge.encoding).to eq(Encoding::UTF_8)
      end
    end

    context 'when challenge_method is NOT given' do
      subject(:code_challenge) do
        described_class.code_challenge(code_verifier)
      end

      include_examples 'S256'
    end
  end

  describe '#code_verifier' do
    before do
      allow(described_class).to(
        receive(:code_verifier).and_return('*' * 5)
      )
    end

    context 'when code_verifier is given' do
      subject do
        described_class
          .new(code_verifier: code_verifier).code_verifier
      end

      let(:code_verifier) { Faker::Alphanumeric.alpha(number: 5) }

      it 'returns a same string as given' do
        is_expected.to eq(code_verifier)
        expect(described_class).not_to have_received(:code_verifier)
      end
    end

    context 'when code_verifier is NOT given' do
      subject { described_class.new.code_verifier }

      it 'generate a code_verifier' do
        is_expected.to eq('*' * 5)
        expect(described_class).to(
          have_received(:code_verifier).with(no_args).once
        )
      end
    end
  end

  describe '#code_challenge' do
    before do
      allow(described_class).to(
        receive(:code_challenge).and_return('*' * 5)
      )
    end

    context 'when code_verifier is given' do
      subject do
        described_class
          .new(code_verifier: code_verifier)
          .code_challenge
      end

      let(:code_verifier) { Faker::Alphanumeric.alpha(number: 5) }

      it 'generate a code_challenge by given params' do
        is_expected.to eq('*' * 5)
        expect(described_class).to(
          have_received(:code_challenge)
            .with(code_verifier, 'S256')
            .once
        )
      end
    end

    context 'when code_challenge_method is given' do
      subject do
        described_class
          .new(code_challenge_method: 'plain')
          .code_challenge
      end

      let(:code_verifier) { Faker::Alphanumeric.alpha(number: 5) }

      before do
        allow(described_class).to(
          receive(:code_verifier).and_return(code_verifier)
        )
      end

      it 'generate a code_challenge by given params' do
        is_expected.to eq('*' * 5)
        expect(described_class).to(
          have_received(:code_challenge)
            .with(code_verifier, 'plain')
            .once
        )
      end
    end

    context 'when code_verifier and code_challenge_method are given' do
      subject do
        described_class
          .new(code_verifier: code_verifier, code_challenge_method: 'plain')
          .code_challenge
      end

      let(:code_verifier) { Faker::Alphanumeric.alpha(number: 5) }

      it 'generate a code_challenge by given params' do
        is_expected.to eq('*' * 5)
        expect(described_class).to(
          have_received(:code_challenge)
            .with(code_verifier, 'plain')
            .once
        )
      end
    end

    context 'when code_verifier and code_challenge_method are NOT given' do
      subject do
        described_class.new.code_challenge
      end

      let(:code_verifier) { Faker::Alphanumeric.alpha(number: 5) }

      before do
        allow(described_class).to(
          receive(:code_verifier).and_return(code_verifier)
        )
      end

      it 'generate a code_challenge by default params' do
        is_expected.to eq('*' * 5)
        expect(described_class).to(
          have_received(:code_challenge)
            .with(code_verifier, 'S256')
            .once
        )
      end
    end
  end

  describe '#code_challenge_method' do
    context 'when code_challenge_method is given' do
      subject do
        described_class
          .new(code_challenge_method: 'plain')
          .code_challenge_method
      end

      it 'returns a code_challenge_method as given' do
        is_expected.to eq('plain')
      end
    end

    context 'when code_challenge_method is NOT given' do
      subject(:code_challenge_method) do
        described_class.new.code_challenge_method
      end

      it 'returns a default code_challenge_method' do
        is_expected.to eq('S256')
      end
    end
  end

  describe '#state' do
    before do
      allow(described_class).to(
        receive(:state).and_return('*' * 5)
      )
    end

    context 'when state is given' do
      subject do
        described_class.new(state: state).state
      end

      let(:state) { Faker::Alphanumeric.alpha(number: 5) }

      it 'returns a same string as given' do
        is_expected.to eq(state)
        expect(described_class).not_to have_received(:state)
      end
    end

    context 'when state is NOT given' do
      subject { described_class.new.state }

      it 'generate a state' do
        is_expected.to eq('*' * 5)
        expect(described_class).to(
          have_received(:state).with(no_args).once
        )
      end
    end
  end
end
