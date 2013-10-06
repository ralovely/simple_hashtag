class Post < ActiveRecord::Base
  include SimpleHashtag::Hashtaggable
end
