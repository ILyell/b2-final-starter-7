class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item

  enum status: [:pending, :packaged, :shipped]

  def discounted_revenue
    discount_item = InvoiceItem.discount(self.id)
    if discount_item != nil
      discount_item.revenue - (discount_item.revenue * discount_item.percentage)
    else
      self.quantity * self.unit_price
    end
    
  end


  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def self.discount(invoice_item_id) 
    InvoiceItem.joins(item: [merchant: :bulk_discounts])
      .where("invoice_items.id = #{invoice_item_id} AND invoice_items.quantity >= bulk_discounts.quantity_threshold")
      .select("bulk_discounts.*, invoice_items.*, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue")
      .group("bulk_discounts.id, invoice_items.id")
      .order("quantity_threshold DESC")
      .limit(1)
      .first
  end
end
