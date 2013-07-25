class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end

    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    # creates uniqueness of pairings so that users can't follow someone more than once!
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end