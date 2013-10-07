module SimpleHashtag
  module Generators
    class ViewsGenerator < Rails::Generators::Base

      source_root File.expand_path('../templates', __FILE__)

      def generate_views
        copy_file "views/hashtags_controller.rb", "app/controllers/hashtags_controller.rb"
        copy_file "views/hashtags_helper.rb", "app/helpers/hashtags_helper.rb"
        copy_file "views/hashtags_index.html.erb", "app/views/hashtags/index.html.erb"
        copy_file "views/hashtags_show.html.erb", "app/views/hashtags/show.html.erb"

        route 'get "hashtags",            to: "hashtags#index",     as: :hashtags'
        route 'get "hashtags/:hashtag",   to: "hashtags#show",      as: :hashtag'
      end
    end
  end
end
