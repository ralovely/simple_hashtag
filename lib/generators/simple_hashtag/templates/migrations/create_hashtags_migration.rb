# This migration comes from simple_hashtag
class CreateSimpleHashtagHashtags < ActiveRecord::Migration
  def change
    create_table :simple_hashtag_hashtags do |t|
      t.string :name,             :index => true

      t.timestamps
    end
  end
end
