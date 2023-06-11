RSpec.describe TwitterTweetBot::API::Params::PlainParam do
  describe '::build' do
    subject { described_class.build('foo', 'bar') }

    it 'returns params for an API request' do
      is_expected.to eq({ 'foo' => 'bar' })
    end
  end
end
