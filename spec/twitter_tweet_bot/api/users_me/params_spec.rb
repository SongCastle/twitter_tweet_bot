RSpec.describe TwitterTweetBot::API::UsersMe.const_get(:Params) do # rubocop:disable RSpec/DescribeClass
  describe '::build' do
    subject(:api_params) { described_class.build(params) }

    context 'when param\'s values are string' do
      let(:params) do
        {
          expansions: 'pinned_tweet_id',
          tweet_fields: 'attachments',
          user_fields: 'created_at'
        }
      end

      it 'returns params for UsersMe API' do
        expect(api_params['expansions']).to eq('pinned_tweet_id')
        expect(api_params['tweet.fields']).to eq('attachments')
        expect(api_params['user.fields']).to eq('created_at')
      end

      context 'when param\'s values are included an unknown key' do
        before { params[:unknown] = '*' }

        it 'trims an unknown key' do
          is_expected.not_to have_key(:unknown)
        end
      end
    end

    context 'when param\'s values are included Array' do
      let(:params) do
        {
          expansions: 'pinned_tweet_id',
          tweet_fields: %w[attachments],
          user_fields: %w[created_at description]
        }
      end

      it 'returns params for UsersMe API' do
        expect(api_params['expansions']).to eq('pinned_tweet_id')
        expect(api_params['tweet.fields']).to eq('attachments')
        expect(api_params['user.fields']).to eq('created_at,description')
      end
    end
  end
end
