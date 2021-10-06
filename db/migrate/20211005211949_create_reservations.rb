class CreateReservations < ActiveRecord::Migration[6.1]
  def change
    create_table :reservations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true
      t.datetime :from
      t.datetime :to
      t.string :code
      t.integer :status

      t.timestamps
    end
  end
end
