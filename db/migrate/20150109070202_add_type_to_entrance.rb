class AddTypeToEntrance < ActiveRecord::Migration
  def change
    add_column :entrances, :entrance_type, :integer
  end
end
