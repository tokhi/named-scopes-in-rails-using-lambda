class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.string :description
      t.string :keywords
      t.boolean :publish

      t.timestamps
    end
  end
end
