class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.string :loan_type
      t.string :description

      t.timestamps
    end
  end
end
