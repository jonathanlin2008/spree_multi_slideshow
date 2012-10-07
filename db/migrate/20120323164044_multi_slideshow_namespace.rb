class AddSlideThumbnails < ActiveRecord::Migration
  def change
    change_table :spree_slideshow_types do |t|
      t.boolean :enable_slide, :default => true

      t.integer :thumbnail_width, :default => 200
      t.integer :thumbnail_height, :default => 80
      t.boolean :enable_thumbnail, :default => true
    end
  end
end
