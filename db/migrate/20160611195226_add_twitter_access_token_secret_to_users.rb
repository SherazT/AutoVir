class AddTwitterAccessTokenSecretToUsers < ActiveRecord::Migration
  def change
    add_column :users, :twitter_access_token_secret, :string
  end
end
