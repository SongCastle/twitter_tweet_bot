RSpec.describe TwitterTweetBot::Entity::Base do
  let(:entity_klass) do
    Class.new.tap do |klass|
      klass.instance_exec(described_class) do |mod|
        include mod

        act_as_entity :foo, :bar, :baz
      end
    end
  end

  let(:data) do
    {
      foo: 'piyo',
      bar: 'piyopiyo',
      baz: 'piyopiyopiyo'
    }
  end

  describe '::build' do
    subject(:entity) { entity_klass.build(data) }

    before do
      allow(entity_klass).to receive(:new).and_call_original
    end

    it 'returns an entity object' do
      expect(entity).to be_a(entity_klass)
      expect(
        entity_klass
      ).to have_received(:new).with(data).once
    end
  end

  describe '#foo' do
    subject { entity_klass.new(data).foo }

    it 'returns an attribute (#foo)' do
      is_expected.to eq(data[:foo])
    end
  end

  describe '#bar' do
    subject { entity_klass.new(data).bar }

    it 'returns an attribute (#bar)' do
      is_expected.to eq(data[:bar])
    end
  end

  describe '#baz' do
    subject { entity_klass.new(data).baz }

    it 'returns an attribute (#baz)' do
      is_expected.to eq(data[:baz])
    end
  end
end
