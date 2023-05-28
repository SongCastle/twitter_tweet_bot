module Spec
  module TwitterTweetBot
    module Entity
      module BaseExamples
        # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        def self.included(base)
          base.shared_examples 'act_as_entity' do |fields|
            describe '::build' do
              subject(:entity) { described_class.build(body) }

              before do
                allow(described_class).to receive(:new).and_call_original
              end

              it 'returns an entity object' do
                expect(entity).to be_a(described_class)
                expect(
                  described_class
                ).to have_received(:new).with(data).once
              end
            end

            fields.each do |field|
              describe "##{field}" do
                subject { described_class.new(data).public_send(field) }

                it "returns an attribute (##{field})" do
                  is_expected.to eq(data[field])
                end
              end
            end
          end
        end
        # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
      end
    end
  end
end
