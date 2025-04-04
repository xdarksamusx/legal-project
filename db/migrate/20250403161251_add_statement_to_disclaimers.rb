class AddStatementToDisclaimers < ActiveRecord::Migration[8.0]
  def change
    add_column :disclaimers, :staement, :string
  end
end
