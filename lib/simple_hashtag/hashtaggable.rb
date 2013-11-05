module SimpleHashtag
  module Hashtaggable
    extend ActiveSupport::Concern

    included do
      has_many :hashtaggings, as: :hashtaggable,  class_name: "SimpleHashtag::Hashtagging", dependent: :destroy
      has_many :hashtags, through: :hashtaggings, class_name: "SimpleHashtag::Hashtag"

      before_save :update_hashtags

      def hashtaggable_content
        self.class.hashtaggable_attribute # to ensure it has been called at least once
        content = self.send(self.class.hashtaggable_attribute_name)
        content.to_s
      end

      def update_hashtags
        self.hashtags = parsed_hashtags
      end

      def parsed_hashtags
        parsed_hashtags = []
        array_of_hashtags_as_string = scan_for_hashtags(hashtaggable_content)
        array_of_hashtags_as_string.each do |s|
          parsed_hashtags << Hashtag.find_or_create_by_name(s[1])
        end
        parsed_hashtags
      end

      def scan_for_hashtags(content)
        match = content.scan(Hashtag::HASHTAG_REGEX)
        match.uniq!
        match
      end
    end

    module ClassMethods
      attr_accessor :hashtaggable_attribute_name

      def hashtaggable_attribute(name=nil)
        self.hashtaggable_attribute_name ||= name || :body
      end
    end
  end
end
