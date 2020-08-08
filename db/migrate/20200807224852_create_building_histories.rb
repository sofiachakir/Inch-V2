class CreateBuildingHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :building_histories do |t|
      t.string :manager_name
      t.belongs_to :building, index: true

      t.timestamps
    end
  end
end
