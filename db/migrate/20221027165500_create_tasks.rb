class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.integer :priority, default: 0
      t.date :due_date
      t.integer :status, default: 0
      t.references :section
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
