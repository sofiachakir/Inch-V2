class CreatePersonHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :person_histories do |t|
      t.string :email
      t.string :home_phone_number
      t.string :mobile_phone_number
      t.string :address
      t.belongs_to :person, index: true

      t.timestamps
    end
  end
end
