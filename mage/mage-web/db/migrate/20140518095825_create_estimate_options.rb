class CreateEstimateOptions < ActiveRecord::Migration
  def change
    create_table :estimate_options do |t|
      t.string :value

      t.timestamps
    end
  end
end
