module Spec
  module TwitterTweetBot
    module Entity
      module BaseExamples
        def self.included(base)
          base.shared_examples 'act_as_entity' do |fields|
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
      end
    end
  end
end
