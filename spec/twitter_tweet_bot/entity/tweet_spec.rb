RSpec.describe TwitterTweetBot::Entity::Tweet do
  include Spec::TwitterTweetBot::Entity::BaseExamples

  it_behaves_like 'act_as_entity', %i[
    id
    text
    edit_history_tweet_ids
  ] do
    let(:body) do
      {
        data: {
          id: Faker::Internet.uuid,
          text: Faker::Lorem.word,
          edit_history_tweet_ids: [Faker::Internet.uuid]
        }
      }
    end

    let(:data) { body[:data] }
  end
end
