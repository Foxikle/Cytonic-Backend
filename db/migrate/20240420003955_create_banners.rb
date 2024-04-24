class CreateBanners < ActiveRecord::Migration[7.1]
  def change
    create_table :banners do |t|
      t.string :body
      t.string :title
      t.string :style
      t.timestamps
    end
  end
end
