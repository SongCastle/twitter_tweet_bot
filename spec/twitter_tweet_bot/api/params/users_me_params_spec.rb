RSpec.describe TwitterTweetBot::API::Params::UsersMeParams do
  describe '::build' do
    context 'without block' do
      subject { described_class.build }

      it 'returns an empty hash' do
        is_expected.to eq({})
      end
    end

    context 'with block' do
      context 'when params values are string' do
        subject do
          described_class.build do |params|
            params.expansions = 'pinned_tweet_id'
            params.tweet_fields = 'attachments'
            params.user_fields = 'created_at'
          end
        end

        it 'returns params for UsersMe API' do
          is_expected.to eq(
            {
              'expansions' => 'pinned_tweet_id',
              'tweet.fields' => 'attachments',
              'user.fields' => 'created_at'
            }
          )
        end
      end

      context 'when params values are included Array' do
        subject do
          described_class.build do |params|
            params.expansions = 'pinned_tweet_id'
            params.tweet_fields = %w[attachments]
            params.user_fields = %w[created_at description]
          end
        end

        it 'returns params for UsersMe API' do
          is_expected.to eq(
            {
              'expansions' => 'pinned_tweet_id',
              'tweet.fields' => 'attachments',
              'user.fields' => 'created_at,description'
            }
          )
        end
      end
    end
  end
end
