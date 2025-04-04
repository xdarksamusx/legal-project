class RemoveLegalNoticeFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :legal_notice, :string
    remove_column :users, :user_input, :string
  end
end
