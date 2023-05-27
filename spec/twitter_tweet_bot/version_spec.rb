RSpec.describe TwitterTweetBot do
  describe '::VERSION' do
    it 'returns a current version' do
      expect(described_class::VERSION).to eq('1.0.0')
    end
  end
end
