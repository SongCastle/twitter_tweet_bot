require 'twitter_tweet_bot/api/params/string_param'

RSpec.describe TwitterTweetBot::API::Params::StringParam do
  describe '::build' do
    subject { described_class.build('foo', value) }

    context 'when a value is String' do
      let(:value) { 'bar' }

      it 'returns params for an API request' do
        is_expected.to eq({ 'foo' => value })
      end
    end

    context 'when a value is NOT String' do
      let(:value) { Faker::Boolean.boolean }

      it 'returns params for an API request' do
        is_expected.to eq({})
      end
    end
  end
end
