# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do
  context 'ActiveRecord validations' do
    it 'name should be present' do
      expect(FactoryBot.build(:user, name: nil)).to_not be_valid
    end

    let!(:some_user) { FactoryBot.create(:user, name: 'some_name') }

    it 'name should be unique' do
      expect(FactoryBot.build(:user, name: 'some_name')).to_not be_valid
    end
  end

  let(:user) do
    FactoryBot.create(:user, name: 'SuPEr CoOl      Name')
  end

  context 'Makes name to lowercase and whitespaces removed' do
    it 'should sanitize name' do
      expect(user.name).to eq('super cool name')
    end
  end
end
