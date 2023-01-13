require 'rails_helper'

RSpec.describe User, type: :model do
  context 'before_create :build_inbox' do
    it 'creates a default inbox project' do
      user = create(:user)
      expect(user.inbox).not_to be_nil
    end
  end
end
