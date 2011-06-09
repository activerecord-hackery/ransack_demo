class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.belongs_to :tag
      t.integer :taggable_id
      t.string :taggable_type

      t.timestamps
    end
    add_index :taggings, :tag_id
  end
end
