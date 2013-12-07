class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.datetime :start
      t.datetime :finish
      t.text :comment
      t.references :project, index: true

      t.timestamps
    end
  end
end
