class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :content
      t.belongs_to :category
      t.belongs_to :user

      t.timestamps
    end
    add_index :articles, :category_id
    add_index :articles, :user_id
  end
end
