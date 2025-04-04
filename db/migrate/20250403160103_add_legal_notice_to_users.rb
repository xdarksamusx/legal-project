class AddLegalNoticeToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :legal_notice, :string
    add_column :users, :user_input, :string
  end
end
