class AddUserReferenceToDisclaimers < ActiveRecord::Migration[8.0]
  def change
    add_reference :disclaimers, :user, null: false, foreign_key: true
  end
end
