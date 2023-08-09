class BulkDiscount < ApplicationRecord
    validates_presence_of :name,
    :quantity_threshold,
    :percentage,
    :merchant_id

    belongs_to :merchant
end