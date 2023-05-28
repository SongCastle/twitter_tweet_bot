RSpec.describe TwitterTweetBot::Entity::User do
  include Spec::TwitterTweetBot::Entity::BaseExamples

  it_behaves_like 'act_as_entity', %i[
    id
    name
    username
  ] do
    let(:body) do
      {
        data: {
          id: Faker::Internet.uuid,
          name: Faker::Internet.username,
          username: Faker::Name.first_name
        }
      }
    end

    let(:data) { body[:data] }
  end
end
