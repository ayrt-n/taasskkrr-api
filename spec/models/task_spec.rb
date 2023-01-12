require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Task, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:title) }
  end
end
