class BulkDiscountsController < ApplicationController
    
    def index
        @merchant = Merchant.find(params[:merchant_id])
        @discounts = @merchant.bulk_discounts
    end

    def new
        @merchant = Merchant.find(params[:merchant_id])
    end

    def create
        @merchant = Merchant.find(params[:merchant_id])
        BulkDiscount.create!(name: params[:name],
                    quantity_threshold: params[:quantity_threshold],
                    percentage: params[:percentage].to_f / 100,
                    merchant: @merchant)
        redirect_to merchant_bulk_discounts_path(@merchant)
    end
end