# This migration comes from simple_hashtag
class CreateSimpleHashtagHashtaggings < ActiveRecord::Migration
  def change
    create_table :simple_hashtag_hashtaggings do |t|
      t.references :hashtag,      :index => true
      t.references :hashtaggable, :polymorphic => true
    end
    add_index :simple_hashtag_hashtaggings, ["hashtaggable_id", "hashtaggable_type"],
              :name => 'index_hashtaggings_hashtaggable_id_hashtaggable_type'
  end
end
