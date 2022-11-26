class AddInboxFlagToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :inbox, :boolean, default: false
  end
end
