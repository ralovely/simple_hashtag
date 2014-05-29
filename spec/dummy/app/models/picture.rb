class Picture < ActiveRecord::Base
  include SimpleHashtag::Hashtaggable
  hashtaggable_attribute :caption
  attr_accessible :caption
end
