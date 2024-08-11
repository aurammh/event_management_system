require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:user) { FactoryBot.create(:user) }

  it "is valid with valid attributes" do
    event = FactoryBot.build(:event, creator: user)
    expect(event).to be_valid
  end

  it "is not valid without a name" do
      event = FactoryBot.build(:event, creator: user, name: nil)
      expect(event).not_to be_valid
  end
end