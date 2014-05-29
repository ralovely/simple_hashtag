class Post < ActiveRecord::Base
  include SimpleHashtag::Hashtaggable
  attr_accessible :body
end
