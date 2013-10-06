module SimpleHashtag
  class Hashtagging < ActiveRecord::Base
    self.table_name = "simple_hashtag_hashtaggings"

    belongs_to :hashtag
    belongs_to :hashtaggable, polymorphic: true
  end
end
