# This migration comes from simple_hashtag
class CreateSimpleHashtagHashtaggings < ActiveRecord::Migration
  def change
    create_table :simple_hashtag_hashtaggings do |t|
      t.references :hashtag,      :index => { :name => 'index_hashtaggings_hashtag' }
      t.references :hashtaggable, :polymorphic => true, :index => { :name => 'index_hashtaggings_hashtaggable' }
    end
    add_index :simple_hashtag_hashtaggings, ["hashtaggable_id", "hashtaggable_type"],
              :name => 'index_hashtaggings_hashtaggable_id_hashtaggable_type'
  end
end
