class ChangeColumnsToFeedbacks < ActiveRecord::Migration[5.1]
  def change
    rename_column :feedbacks, :delivery_report, :product_quality
    rename_column :feedbacks, :others, :customer_service
  end
end
