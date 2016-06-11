class CreateUserAcquisitions < ActiveRecord::Migration
  def change
    create_table :user_acquisitions do |t|

      t.timestamps null: false
    end
  end
end
