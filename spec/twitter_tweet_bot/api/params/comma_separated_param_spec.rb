RSpec.describe TwitterTweetBot::API::Params::CommaSeparatedParam do
  describe '::build' do
    context 'when value is Array' do
      subject { described_class.build('foo', %w[hoge fuga]) }

      it 'returns combined params for an API request' do
        is_expected.to eq({ 'foo' => 'hoge,fuga' })
      end
    end

    context 'when value is NOT Array' do
      subject { described_class.build('foo', 'bar') }

      it 'returns params for an API request' do
        is_expected.to eq({ 'foo' => 'bar' })
      end
    end
  end
end
