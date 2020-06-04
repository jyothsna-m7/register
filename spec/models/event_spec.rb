require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:event) { FactoryBot.create(:event, user: user, clock_in: Time.now - 10, clock_out: Time.now) }

  context 'associations' do
    describe 'client' do
      it 'should belong to user' do
        expect(event.user).to eq(user)
      end
    end
  end

  context 'ActiveRecord validations' do
    it 'user should be present' do
      expect(FactoryBot.build(:event, user: nil)).to_not be_valid
    end

    it 'clock_in time cant be in futue' do
      expect(FactoryBot.build(:event, user: user, clock_in: Faker::Time.forward(days: 2))).to_not be_valid
    end

    it 'clock_in time cant be in futue' do
      expect(FactoryBot.build(:event, user: user, clock_in: Time.now, clock_out: Faker::Time.forward(days: 2))).to_not be_valid
    end
  end
end
