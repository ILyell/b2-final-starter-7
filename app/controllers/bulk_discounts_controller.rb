class BulkDiscountsController < ApplicationController
    
    def index
        @merchant = Merchant.find(params[:merchant_id])
        @discounts = @merchant.bulk_discounts
        @holidays = NagerService.new.next_holidays
    end

    def destroy
        BulkDiscount.find(params[:id]).destroy
        redirect_to merchant_bulk_discounts_path(params[:merchant_id])
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
            flash.notice = "Succesfully Updated Bulk Discount."
            redirect_to merchant_bulk_discount_path(@merchant, @discount)
        else
            flash.notice = "All fields must be completed."
            redirect_to edit_merchant_bulk_discount_path(@merchant, @discount)
        end
    end

    def create
        @merchant = Merchant.find(params[:merchant_id])
        @discount = BulkDiscount.new(name: params[:name],
                    quantity_threshold: params[:quantity_threshold],
                    percentage: params[:percentage].to_f / 100,
                    merchant: @merchant)
        if @discount.save
            flash.notice = "Succesfully Create Bulk Discount."
            redirect_to merchant_bulk_discounts_path(@merchant)
        else
            flash.notice = "All fields must be completed."
            redirect_to new_merchant_bulk_discount_path(@merchant)
        end
    end

    private

    def discount_params
    params.require(:bulk_discount).permit(:name, :quantity_threshold, :percentage)
    end
end