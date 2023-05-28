RSpec.describe TwitterTweetBot::Entity::Token do
  include Spec::TwitterTweetBot::Entity::BaseExamples

  it_behaves_like 'act_as_entity', %i[
    token_type
    expires_in
    scope
    access_token
    refresh_token
  ] do
    let(:body) do
      {
        token_type: 'bearer',
        expires_in: 7200,
        scope: %w[tweet.read tweet.write users.read offline.access],
        access_token: Faker::Alphanumeric.alpha(number: 5),
        refresh_token: Faker::Alphanumeric.alpha(number: 5)
      }
    end

    let(:data) { body }
  end
end
