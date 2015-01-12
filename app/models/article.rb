class Article < ActiveRecord::Base
  scope :publish, lambda { where(:publish => true) }
  scope :unpublish, lambda { where(:publish => false) }
  scope :sorted, lambda { order("position ASC") } 
  scope :newest, lambda { order("articles.created_at DESC") }  
  # using parameters
  scope :search, lambda {|query|
    where(["title LIKE ?", "%#{query}%"])
  }
end
