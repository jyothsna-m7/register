# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Event, type: :model do
  let!(:user) { FactoryBot.create(:user) }
  let!(:user1) { FactoryBot.create(:user) }
  let!(:event) { FactoryBot.create(:event, user: user, clock_in: Faker::Time.backward(days: 2), clock_out: nil) }

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

    it 'clock_in should be present' do
      expect(FactoryBot.build(:event, user: user1, clock_in: nil)).to_not be_valid
    end

    it 'clock_in time cant be in futue' do
      expect(FactoryBot.build(:event, user: user, clock_in: Faker::Time.forward(days: 2))).to_not be_valid
    end
  end

  context 'validate clock_in' do
    it 'clock_in time cant be in futue' do
      expect(FactoryBot.build(:event, user: user, clock_in: Time.zone.now, clock_out: Faker::Time.forward(days: 2))).to_not be_valid
    end

    describe 'create new event' do
      context 'when there is a pending event' do
        let!(:event2) { FactoryBot.build(:event, user: user, clock_in: event.clock_in, clock_out: nil) }

        it 'fails with a error message' do
          expect(event2.valid?).to eq(false)
          expect(event2.errors.messages[:clock_in]).to eq(["can not be done, please clock_out the pending one"])
        end
      end

      context 'with clock_in time overlapping with old event' do
        let!(:user1) { FactoryBot.create(:user) }
        let!(:event1) { FactoryBot.build(:event, user: user1, clock_in: Faker::Time.forward(days: 2), clock_out: Time.zone.now) }
        let!(:event2) { FactoryBot.build(:event, user: user1, clock_in: event1.clock_in + 10, clock_out: nil) }

        it 'fails with an error message' do
          event.update(clock_out: Faker::Time.backward(days: 1))
          expect(event2.valid?).to eq(false)
          expect(event2.errors.messages[:clock_in]).to eq(["cannot be in the future"])
        end
      end

      context 'no pending event and no overlapping' do
        let!(:user1) { FactoryBot.create(:user) }
        let!(:event1) { FactoryBot.create(:event, user: user1, clock_in: Faker::Time.backward(days: 2), clock_out: Faker::Time.backward(days: 1)) }
        let!(:event2) { FactoryBot.build(:event, user: user1, clock_in: Time.zone.now, clock_out: nil) }

        it 'succeeds' do
          expect(event2.valid?).to eq(true)
        end
      end
    end

    describe 'update event' do
      context 'with clock_out date in future' do
        let!(:user1) { FactoryBot.create(:user) }
        let!(:event2) { FactoryBot.build(:event, user: user1, clock_in: Time.zone.now - 10, clock_out: Faker::Time.forward(days: 1)) }

        it 'fails with a error message' do
          expect(event2.valid?).to eq(false)
          expect(event2.errors.messages[:clock_out]).to eq(["cannot be in the future"])
        end
      end

      context 'with clock_out time in present time' do
        let!(:user1) { FactoryBot.create(:user) }
        let!(:event2) { FactoryBot.build(:event, user: user1, clock_in: Faker::Time.backward(days: 1), clock_out: Time.zone.now) }

        it 'fails with an error message' do
          expect(event2.valid?).to eq(true)
        end
      end
    end
  end
end
