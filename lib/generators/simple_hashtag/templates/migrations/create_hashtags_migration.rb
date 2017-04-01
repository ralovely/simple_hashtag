# This migration comes from simple_hashtag
class CreateSimpleHashtagHashtags < ActiveRecord::Migration
  def change
    create_table :simple_hashtag_hashtags do |t|
      t.string :name,             :index => { :name => 'index_hashtags_name' }

      t.timestamps
    end
  end
end
