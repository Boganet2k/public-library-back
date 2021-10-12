class AddDeletedAtToBook < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :deleted_at, :datetime
  end
end
