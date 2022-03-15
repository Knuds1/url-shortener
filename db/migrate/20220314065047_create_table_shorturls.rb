class CreateTableShorturls < ActiveRecord::Migration[7.0]
  def change
    create_table :shorturls do |t|
      t.string :url, null: false
      t.string :target, null: false
    end

    add_index :shorturls, :url, unique: true
  end
end
