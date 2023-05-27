RSpec.describe TwitterTweetBot::Version do
  describe '::current' do
    subject(:current) { described_class.current }

    it 'returns a current version' do
      expect(current).to be_a(Gem::Version)
      expect(current.version).to eq('1.0.0')
    end
  end
end
