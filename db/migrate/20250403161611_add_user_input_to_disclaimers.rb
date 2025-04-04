class AddUserInputToDisclaimers < ActiveRecord::Migration[8.0]
  def change
    add_column :disclaimers, :user_input, :string
  end
end
