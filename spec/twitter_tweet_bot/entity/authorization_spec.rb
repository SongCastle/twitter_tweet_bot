RSpec.describe TwitterTweetBot::Entity::Authorization do
  include Spec::TwitterTweetBot::Entity::BaseExamples

  it_behaves_like 'act_as_entity', %i[
    url
    code_verifier
    state
  ] do
    let(:body) do
      {
        url: Faker::Internet.url,
        code_verifier: Faker::Alphanumeric.alpha(number: 5),
        state: Faker::Alphanumeric.alpha(number: 5)
      }
    end

    let(:data) { body }
  end
end
