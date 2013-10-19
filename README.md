# SimpleHashtag

[![Gem Version](https://badge.fury.io/rb/simple_hashtag.png)](http://badge.fury.io/rb/simple_hashtag)
[![Code Climate](https://codeclimate.com/github/ralovely/simple_hashtag.png)](https://codeclimate.com/github/ralovely/simple_hashtag)

Ruby gem for Rails that parses, stores, retreives and formats hashtags in your model.

_Simple Hashtag_ is a mix between–well–hashtags, as we know them, and categories.
It will scan your Active Record attribute for a hashtag, store it in an index, and display a page with each object containing the tag.

It's simple, and like all things simple, it can create a nice effect, quickly.

## Installation

Add this line to your application's Gemfile:
```ruby
gem 'simple_hashtag'
```

And execute:
```shell
$ bundle
```

Then you have to generate the migration files:
```shell
$ rails g simple_hashtag:migration
```

This will create two migration files, one for the `hashtags` table and one for the `hashtagging` table.
You will need to run `rake db:migrate` to actually create the tables.

__Optionnally__, you can create views,
if only to guide you through your own implementation:
```shell
$ rails g simple_hashtag:views
```

This will create a __basic controller__, a __short index view__ and a __small helper__.
It assume your views follow the convention of having a directory named after your model's plural, and a partial named after your model's name.
```
app
|-- views
|    |-- posts
|    |    |-- _post.html.erb
```


## Usage

Just add `include SimpleHashtag::Hashtaggable` in your model.

_Simple Hasthag_ will parse the `body` attribute by default:

```ruby
class Post < ActiveRecord::Base
  include SimpleHashtag::Hashtaggable
end
```


If you need to parse another attribute instead,
add `hashtaggable_attribute` followed by the name of your attribute, i.e.:
```ruby
class Picture < ActiveRecord::Base
  include SimpleHashtag::Hashtaggable
  hashtaggable_attribute :caption
end
```

From here on, if your text contains a hashtag, say _#RubyRocks_,
_Simple Hasthag_ will find it, store it in a table and retreive it and its associated object if asked.
Helpers are also available to create a link when displaying the text.

### Controller and Views
If you don't want to bother looking at the genrerated controller and views, here is a quick peek.
In a Controller, display all hashtags, or search for a Hashtag and its associated records:
```ruby
class HashtagsController < ApplicationController
  def index
    @hashtags = SimpleHashtag::Hashtag.all
  end

  def show
    @hashtag = SimpleHashtag::Hashtag.find_by_name(params[:hashtag])
    @hashtagged = @hashtag.hashtaggables if @hashtag
  end
end
```

The views could resemble something like this:

Index:
```erb
<h1>Hashtags</h1>
<ul>
<% @hashtags.each do |hashtag| %>
  <li><%= link_to hashtag.name, hashtag_path(hashtag.name) %></li>
<% end -%>
</ul>
```

Show:
```erb
<h1><%= params[:hashtag] %></h1>
<% if @hashtagged %>
  <% @hashtagged.each do |hashtagged| %>
    <% view    = hashtagged.class.to_s.underscore.pluralize %>
    <% partial = hashtagged.class.to_s.underscore %>
    <%= render "#{view}/#{partial}", {partial.to_sym => hashtagged} %>
  <% end -%>
<% else -%>
  <p>There is no match for the <em><%= params[:hashtag] %></em> hashtag.</p>
<% end -%>
```
In the gem it is actually extracted in a helper.


### Routes

If you use the provided controller and views, the generator will add two routes to your app:
```ruby
get 'hashtags/',         to: 'hashtags#index',     as: :hashtags
get 'hashtags/:hashtag', to: 'hashtags#show',      as: :hashtag
```

The helper generating the link relies on it.



### Spring Cleaning
There is a class method `SimpleHashtag::Hashtag#clean_orphans` to remove unused hashtags from the DB.
It is currently not hooked, for two reasons:
- It is not optimised at all, DB-wise.
- Destructive method should be called explicitly.

Knowing all this, you can hook it after each change, or automate it with a Cron job, or even spring-clean manually once in a while.

Improvements for this method are listed in the Todo section below.


## Gotchas
### Association Query
The association between a Hashtag and your models is a polymorphic many-to-many.

The object returned by the query is an array, not an Arel query, so you can't chain (i.e.: to specify the order), and should do it by hand:

```ruby
hashtag = SimpleHashtag.find_by_name("RubyRocks")
posts_and_picts = hashtag.hattaggables
posts_and_picts.sort_by! { |p| p.created_at }
```

### find_by

To preserve coherence, Hashtags are stored downcased.
To ensure coherence, they are also searched downcased.
Internally, the model overrides `find_by_name` to perform the downcase query.
Should you search Hashtags manually you should use the `SimpleHashtag::Hashtag#find_by_name` method, instead of `SimpleHashtag::Hashtag.find_by(name: 'RubyRocks')`


## ToDo

_Simple Hashtag_ is in its very early stage and would need a lot of love to reach 1.0.0.
Among the many improvement areas:

- Make the Regex that parses the text for the hashtag much more robust.
  This is how Twitter does it:
  [https://github.com/twitter/twitter-text-rb/blob/master/lib/twitter-text/regex.rb](https://github.com/twitter/twitter-text-rb/blob/master/lib/twitter-text/regex.rb)
  (Yes, that's 362 lines of regex. Neat.)
- Allow for multiple hashtagable attributes on the same model
- Allow a change in the name of the classes and tables to avoid conflicts
- Make it ORM agnostic
- Add an option so the helper displays the `#` or not, global or per model
- Add an option to clean orphans after each edit or not
- Improve the `SimpleHashtag::Hashtag#clean_orphans` method to do only one SQL query

## Contributing

All contributions are welcome.
I might not develop new features (unless a project does require it),
but I will definitely merge any interesting feature or bug fix quickly.

You know the drill:

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add passing tests
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
