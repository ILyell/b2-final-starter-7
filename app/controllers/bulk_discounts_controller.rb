class BulkDiscountsController < ApplicationController
    
    def index
        @merchant = Merchant.find(params[:merchant_id])
        @discounts = @merchant.bulk_discounts
    end

    def show
        @merchant = Merchant.find(params[:merchant_id])
        @discount = BulkDiscount.find(params[:id])
    end

    def edit
        @merchant = Merchant.find(params[:merchant_id])
        @discount = BulkDiscount.find(params[:id])
    end

    def new
        @merchant = Merchant.find(params[:merchant_id])
    end
    
    def update
        @merchant = Merchant.find(params[:merchant_id])
        @discount = BulkDiscount.find(params[:id])
        if @discount.update(discount_params)
          flash.notice = "Succesfully Updated Discount!"
          redirect_to merchant_bulk_discount_path(@merchant, @discount)
        else
          flash.notice = "All fields must be completed."
          redirect_to edit_merchant_bulk_discount_path(@merchant, @discount)
        end
      end

    def create
        @merchant = Merchant.find(params[:merchant_id])
        BulkDiscount.create!(name: params[:name],
                    quantity_threshold: params[:quantity_threshold],
                    percentage: params[:percentage].to_f / 100,
                    merchant: @merchant)
        redirect_to merchant_bulk_discounts_path(@merchant)
    end

    private

    def discount_params
    params.require(:bulk_discount).permit(:name, :quantity_threshold, :percentage)
    end
end