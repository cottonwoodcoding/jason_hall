class CreatePartners < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.string :type
      t.string :name
      t.string :phone
      t.string :address
      t.string :url
      t.text :comment
      t.string :img

      t.timestamps
    end
  end
end
