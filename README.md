# Named Scopes in Rails 4 using lambda

In Rails 4 named scopes requires to use ruby `lambda` syntax; they allows you to customize complex queries very easily. The queries can be defined in a mode and then can be called like `ActiveRelation` methods, in the other hand you can also dizzy chain them together or with other active relation query methods and they can also accept parameters

*Defining a scope:*

```ruby
scope :active, lambda { where(:active => true) }
```
or

```ruby
scope :active, -> { where(:active => true) }
```

*Calling a scope:*
Suppose you have a model called `User`:

```
User.active  # returns all the active users
```
This is great because its a short hand to call very long custom queries.


Lets creat some article via active record, to do that clone the project and execute these in the rails console:

`bin/rails c`:

```ruby
Article.create(:title=>"first title", :description=>"first title description", :publish=>false, :position=>2)


Article.create(:title=>"2nd title", :description=>"about the second title", :publish=>false, :position=>1)

```

## Examples
Here in the Acrticle model we defined two named scopes wich quries the published and unpublished articles:

```ruby
class Article < ActiveRecord::Base
  scope :publish, lambda { where(:publish => true) }
  scope :unpublish, lambda { where(:publish => false) }
end
```
This is how to call the scope via ActiveRecord:

*Published Articles:*

```ruby
Article.publish

  Article Load (0.1ms)  SELECT "articles".* FROM "articles"  WHERE "articles"."publish" = 't'
 => #<ActiveRecord::Relation [#<Article id: 1, title: "first title ", description: "first title description", keywords: nil, publish: true, created_at: "2015-01-11 23:28:44", updated_at: "2015-01-11 23:34:51", position: 2>]>
```

*Unpublished Articles:*

```ruby
2.1.5 :002 > Article.unpublish

  Article Load (0.2ms)  SELECT "articles".* FROM "articles"  WHERE "articles"."publish" = 'f'
 => #<ActiveRecord::Relation [#<Article id: 2, title: "2nd title", description: "about the second title", keywords: nil, publish: false, created_at: "2015-01-11 23:30:02", updated_at: "2015-01-11 23:34:25", position: 1>]>

```

*Sorting articles by position:*

```ruby
2.1.5 :005 > Article.sorted

  Article Load (0.2ms)  SELECT "articles".* FROM "articles"   ORDER BY position ASC
 => #<ActiveRecord::Relation [#<Article id: 2, title: "2nd title", description: "about the second title", keywords: nil, publish: false, created_at: "2015-01-11 23:30:02", updated_at: "2015-01-11 23:34:25", position: 1>, 

 #<Article id: 1, title: "first title ", description: "first title description", keywords: nil, publish: true, created_at: "2015-01-11 23:28:44", updated_at: "2015-01-11 23:34:51", position: 2>]>
```

*Sorting by the newest articles:*

```ruby
2.1.5 :006 > Article.newest

  Article Load (0.2ms)  SELECT "articles".* FROM "articles"   ORDER BY articles.created_at DESC

 => #<ActiveRecord::Relation [#<Article id: 2, title: "2nd title", description: "about the second title", keywords: nil, publish: false, created_at: "2015-01-11 23:30:02", updated_at: "2015-01-11 23:34:25", position: 1>, 

 #<Article id: 1, title: "first title ", description: "first title description", keywords: nil, publish: true, created_at: "2015-01-11 23:28:44", updated_at: "2015-01-11 23:34:51", position: 2>]>
```

*Searching articles:*

```ruby
2.1.5 :007 > Article.search("first")

  Article Load (0.2ms)  SELECT "articles".* FROM "articles"  WHERE (title LIKE '%first%')
 => #<ActiveRecord::Relation [#<Article id: 1, title: "first title ", description: "first title description", keywords: nil, publish: true, created_at: "2015-01-11 23:28:44", updated_at: "2015-01-11 23:34:51", position: 2>]>
```

*Chaining scopes together:*
This will only sort the published articles.
```ruby
2.1.5 :008 > Article.publish.sorted

  Article Load (0.2ms)  SELECT "articles".* FROM "articles"  WHERE "articles"."publish" = 't'  ORDER BY position ASC
 => #<ActiveRecord::Relation [#<Article id: 1, title: "first title ", description: "first title description", keywords: nil, publish: true, created_at: "2015-01-11 23:28:44", updated_at: "2015-01-11 23:34:51", position: 2>]>
```

*All together:*

```
class Article < ActiveRecord::Base
  scope :publish, lambda { where(:publish => true) }
  scope :unpublish, lambda { where(:publish => false) }
  scope :sorted, lambda { order("position ASC") }
  scope :newest, lambda { order("articles.created_at DESC") }
  scope :search, lambda {|query|
    where(["title LIKE ?", "%#{query}%"])
  }
end
```
