RSpec.describe TwitterTweetBot::API::Params::TweetParams do
  describe '::build' do
    context 'without block' do
      subject { described_class.build }

      it 'returns an empty hash' do
        is_expected.to eq({})
      end
    end

    context 'with block' do
      describe 'for_super_followers_only' do
        subject do
          described_class.build do |params|
            params.for_super_followers_only = for_super_followers_only
          end
        end

        let(:for_super_followers_only) { Faker::Boolean.boolean }

        it 'returns \'for_super_followers_only\' params for Tweet API' do
          is_expected.to eq(
            { for_super_followers_only: for_super_followers_only }
          )
        end
      end

      describe 'direct_message_deep_link' do
        subject do
          described_class.build do |params|
            params.direct_message_deep_link = direct_message_deep_link
          end
        end

        let(:direct_message_deep_link) { Faker::Internet.url }

        it 'returns \'direct_message_deep_link\' params for Tweet API' do
          is_expected.to eq(
            { direct_message_deep_link: direct_message_deep_link }
          )
        end
      end

      describe 'text' do
        subject do
          described_class.build do |params|
            params.text = text
          end
        end

        let(:text) { Faker::Lorem.word }

        it 'returns \'text\' params for Tweet API' do
          is_expected.to eq({ text: text })
        end
      end

      describe 'quote_tweet_id' do
        subject do
          described_class.build do |params|
            params.quote_tweet_id = quote_tweet_id
          end
        end

        let(:quote_tweet_id) { Faker::Internet.uuid }

        it 'returns \'quote_tweet_id\' params for Tweet API' do
          is_expected.to eq({ quote_tweet_id: quote_tweet_id })
        end
      end

      describe 'reply_settings' do
        subject do
          described_class.build do |params|
            params.reply_settings = reply_settings
          end
        end

        let(:reply_settings) { %w[mentionedUsers following].sample }

        it 'returns \'reply_settings\' params for Tweet API' do
          is_expected.to eq({ reply_settings: reply_settings })
        end
      end

      describe 'geo' do
        subject do
          described_class.build do |params|
            params.geo = geo
          end
        end

        let(:geo) do
          { place_id: Faker::Internet.uuid }
        end

        it 'returns \'geo\' params for Tweet API' do
          is_expected.to eq({ geo: geo })
        end
      end

      describe 'media' do
        subject do
          described_class.build do |params|
            params.media = media
          end
        end

        let(:media) do
          {
            media_ids: [Faker::Internet.uuid],
            tagged_user_ids: [Faker::Internet.uuid]
          }
        end

        it 'returns \'media\' params for Tweet API' do
          is_expected.to eq({ media: media })
        end
      end

      describe 'poll' do
        subject do
          described_class.build do |params|
            params.poll = poll
          end
        end

        let(:poll) do
          {
            duration_minutes: 120,
            options: %w[yes maybe no]
          }
        end

        it 'returns \'poll\' params for Tweet API' do
          is_expected.to eq({ poll: poll })
        end
      end

      describe 'reply' do
        subject do
          described_class.build do |params|
            params.reply = reply
          end
        end

        let(:reply) do
          {
            in_reply_to_tweet_id: Faker::Internet.uuid,
            exclude_reply_user_ids: [Faker::Internet.uuid]
          }
        end

        it 'returns \'reply\' params for Tweet API' do
          is_expected.to eq({ reply: reply })
        end
      end
    end
  end
end
