class AddAttachmentContentTypeFieldToAssets < ActiveRecord::Migration[5.1]
  def change
    add_column :assets, :attachment_content_type, :string
  end
end
