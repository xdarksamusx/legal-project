class RenameStaementToStatementInDisclaimers < ActiveRecord::Migration[8.0]
  def change
    rename_column  :disclaimers, :staement, :statement
  end
end
