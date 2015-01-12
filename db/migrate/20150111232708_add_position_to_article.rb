class AddPositionToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :position, :int
  end
end
