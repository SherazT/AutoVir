class ChangeColumnNameUsers < ActiveRecord::Migration
  def change
    rename_column :users, :instagram_access_token, :twitter_access_token
  end
end
