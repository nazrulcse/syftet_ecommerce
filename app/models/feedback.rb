# == Schema Information
#
# Table name: feedback
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  type    :string
#  message    :text
#  delivery_report   :string
#  product_price    :string
#  others    :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


class Feedback < ApplicationRecord
end
