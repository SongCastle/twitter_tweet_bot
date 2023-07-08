RSpec.describe TwitterTweetBot::API::Params::HashParam do
  describe '::build' do
    subject { described_class.build('foo', value) }

    context 'when a value is Hash' do
      let(:value) { { foge: 'huga' } }

      it 'returns params for an API request' do
        is_expected.to eq({ 'foo' => value })
      end
    end

    context 'when a value is NOT Hash' do
      let(:value) { 'bar' }

      it 'returns params for an API request' do
        is_expected.to eq({})
      end
    end
  end
end
