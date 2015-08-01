module SimpleHashtag
  class Hashtag < ActiveRecord::Base
    self.table_name = "simple_hashtag_hashtags"

    has_many :hashtaggings

    validates :name, uniqueness: true

    # TODO Beef up the regex (ie.:what if content is HTML)
    # this is how Twitter does it:
    # https://github.com/twitter/twitter-text-rb/blob/master/lib/twitter-text/regex.rb
    HASHTAG_REGEX = /[\u0600-\u06FF]|[\u0750-\u077F]|[\u0590-\u05FF]|[\uFE70-\uFEFF]/m

    def self.find_by_name(name)
      Hashtag.where("lower(name) =?", name).first
    end
    def self.find_or_create_by_name(name, &block)
      find_by_name(name) || create(name: name, &block)
    end


    def name=(val)
      write_attribute(:name, val.downcase)
    end

    def name
      read_attribute(:name).downcase
    end

    def hashtaggables
      self.hashtaggings.includes(:hashtaggable).collect { |h| h.hashtaggable }
    end

    def hashtagged_types
      self.hashtaggings.pluck(:hashtaggable_type).uniq
    end

    def hashtagged_ids_by_types
      hashtagged_ids ||= {}
      self.hashtaggings.each do |h|
        hashtagged_ids[h.hashtaggable_type] ||= Array.new
        hashtagged_ids[h.hashtaggable_type] << h.hashtaggable_id
      end
      hashtagged_ids
    end

    def hashtagged_ids_for_type(type)
      hashtagged_ids_by_types[type]
    end

    def to_s
      name
    end

    def self.clean_orphans # From DB
      # TODO Make this method call a single SQL query
      orphans = self.all.select { |h| h.hashtaggables.size == 0 }
      orphans.map(&:destroy)
    end

  end
end
