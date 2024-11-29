class AddParentIdToPlutusModels < ActiveRecord::Migration[7.2]
  def change
    add_column :plutus_accounts, :parent_id, :integer

    # Add indexes for efficient querying
    add_index :plutus_accounts, :parent_id
  end
end
