class AddTwitterConnectionToUsers < ActiveRecord::Migration
  def change
    remove_column :users, :twitter_access_token_secret
    remove_column :users, :twitter_access_token
    add_column :users, :twitter, :boolean, default: false
  end
end
