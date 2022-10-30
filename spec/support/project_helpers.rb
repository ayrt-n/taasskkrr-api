require 'faker'
require 'factory_bot_rails'

module ProjectHelpers
  def create_project
    FactoryBot.create(
      :project,
      title: Faker::Lorem.sentence
    )
  end

  def build_project
    FactoryBot.build(
      :project,
      title: Faker::Lorem.sentence
    )
  end
end
