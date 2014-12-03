class CreateProcessSteps < ActiveRecord::Migration
  def change
    create_table :process_steps do |t|
      t.string :name
      t.text :description
      t.integer :step_number

      t.timestamps
    end
  end
end
