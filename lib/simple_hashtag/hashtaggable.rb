module SimpleHashtag
  module Hashtaggable
    extend ActiveSupport::Concern

    class InvalidHashtagGuard < ArgumentError; end

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
        if hashtag_guard.present?
          if hashtag_guard.respond_to?(:call)
            return unless hashtag_guard.call self
          elsif self.respond_to? hashtag_guard
            return unless self.send hashtag_guard
          else
            raise InvalidHashtagGuard
          end
        end

        self.hashtags = parsed_hashtags
      end

      def hashtag_guard
        self.class.hashtag_guard
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
      attr_accessor :hashtag_guard

      def hashtaggable_attribute(name=nil)
        self.hashtaggable_attribute_name ||= name || :body
      end

      def hashtag_if(guard)
        self.hashtag_guard = guard
      end
    end
  end
end
