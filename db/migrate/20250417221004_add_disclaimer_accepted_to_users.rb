class AddDisclaimerAcceptedToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :disclaimer_accepted, :boolean, default: false, null: false
  end
end