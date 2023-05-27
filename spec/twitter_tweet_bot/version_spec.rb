RSpec.describe TwitterTweetBot::Version do
  describe '::current' do
    subject { described_class.current }

    it 'returns a current version' do
      expect(subject).to be_a(Gem::Version)
      expect(subject.version).to eq('1.0.0')
    end
  end
end
