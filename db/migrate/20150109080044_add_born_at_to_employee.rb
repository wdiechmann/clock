class AddBornAtToEmployee < ActiveRecord::Migration
  def change
    add_column :employees, :born_at, :datetime
  end
end
