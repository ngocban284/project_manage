class AddUserIdToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :user_id, :integer
  end
end
