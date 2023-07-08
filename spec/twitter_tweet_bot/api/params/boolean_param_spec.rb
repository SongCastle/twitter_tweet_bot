RSpec.describe TwitterTweetBot::API::Params::BooleanParam do
  describe '::build' do
    subject { described_class.build('foo', value) }

    context 'when a value is true' do
      let(:value) { true }

      it 'returns params for an API request' do
        is_expected.to eq({ 'foo' => value })
      end
    end

    context 'when a value is false' do
      let(:value) { false }

      it 'returns params for an API request' do
        is_expected.to eq({ 'foo' => value })
      end
    end

    context 'when a value is NOT TrueClass/FalseClass' do
      let(:value) { 'true' }

      it 'returns params for an API request' do
        is_expected.to eq({})
      end
    end
  end
end
