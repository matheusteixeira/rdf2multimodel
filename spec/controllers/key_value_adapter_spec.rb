require "rails_helper"

RSpec.describe KeyValueAdapterController, :type => :controller do
  describe 'key and value' do
    let(:triple) { ["John", "Is a Friend of", "James"] }

    it 'returns the key' do
      expect(described_class.new.key(triple)).to eq "John Is a Friend of"
    end

    it 'returns the value' do
      expect(described_class.new.value(triple)).to eq "James"
    end
  end

  describe 'load' do
    let(:triple_one) { ["John", "Is a Friend of", "James"] }
    let(:triple_two) { ["John", "Is a Friend of", "Jesse"] }
    let(:triple_three) { ["Jesse", "Is a Friend of", "Doug"] }

    let(:subject) { KeyValueAdapterController.new }

    before do
      subject.save_triple(triple_one)
      subject.save_triple(triple_two)
      subject.save_triple(triple_three)
    end

    it 'returns the value' do
      expect(subject.load_triple("John Is a Friend of")).to eq ["James", "Jesse"]
      expect(subject.load_triple("Jesse Is a Friend of")).to eq ["Doug"]
    end
  end
end
