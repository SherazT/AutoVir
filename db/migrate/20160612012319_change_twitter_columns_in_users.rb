class ChangeTwitterColumnsInUsers < ActiveRecord::Migration
  def change
    remove_column :users, :twitter
    add_column :users, :twitter_access_token, :string
    add_column :users, :twitter_token_secret, :string
  end
end
