class RemoveAPITokenFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :api_token, :string
  end
end
