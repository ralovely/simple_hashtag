class Picture < ActiveRecord::Base
  include SimpleHashtag::Hashtaggable
  hashtaggable_attribute :caption
end
