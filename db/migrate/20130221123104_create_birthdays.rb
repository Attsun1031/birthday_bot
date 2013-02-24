class CreateBirthdays < ActiveRecord::Migration
  def change
    create_table :birthdays do |t|
      t.string :birthday, :null => false
      t.string :name_en, :null => false
      t.string :name_ja
      t.text :introduction
      t.text :comment
      t.string :link

      t.timestamps
    end
    add_index :birthdays, :birthday
  end
end
