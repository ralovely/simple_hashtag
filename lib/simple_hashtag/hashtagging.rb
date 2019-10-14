module SimpleHashtag
  class Hashtagging < ActiveRecord::Base
    self.table_name = "simple_hashtag_hashtaggings"

    belongs_to :hashtag, counter_cache: true
    belongs_to :hashtaggable, polymorphic: true
  end
end
