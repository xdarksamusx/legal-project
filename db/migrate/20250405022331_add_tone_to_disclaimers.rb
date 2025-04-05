class AddToneToDisclaimers < ActiveRecord::Migration[8.0]
  def change
    add_column :disclaimers, :tone, :string
  end
end
