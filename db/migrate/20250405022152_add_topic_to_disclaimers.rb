class AddTopicToDisclaimers < ActiveRecord::Migration[8.0]
  def change
    add_column :disclaimers, :topic, :string
  end
end
