class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.boolean :published, null: false, default: false
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
    add_index :posts, :title
  end
end
