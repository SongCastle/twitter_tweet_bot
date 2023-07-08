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
                ).to have_received(:new).with(body).once
              end
            end

            describe '#initialize' do
              subject { described_class.new(body) }

              shared_examples 'initialize an entity' do
                it 'initialize an entity' do
                  is_expected.to be_a(described_class)
                end
              end

              include_examples 'initialize an entity'

              context 'when body is nil' do
                let(:body) { nil }

                include_examples 'initialize an entity'
              end
            end

            describe '#raw' do
              subject { described_class.new(body).raw }

              it 'returns a body' do
                is_expected.to be(body)
              end
            end

            fields.each do |field|
              describe "##{field}" do
                subject { described_class.new(body).public_send(field) }

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
