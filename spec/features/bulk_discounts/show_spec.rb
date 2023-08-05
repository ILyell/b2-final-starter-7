require "rails_helper"

RSpec.describe "Bulk Discounts Show Page", type: :feature do
    before(:each) do

    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Strickland Propane")

    @discount1 = @merchant1.bulk_discounts.create!(name: "10% off 10 or more", quantity_threshold: 10, percentage: 0.10)
    @discount2 = @merchant1.bulk_discounts.create!(name: "15% off 20 or more", quantity_threshold: 20, percentage: 0.15)
    @discount3 = @merchant1.bulk_discounts.create!(name: "20% off 30 or more", quantity_threshold: 30, percentage: 0.20)

    @discount4 = @merchant2.bulk_discounts.create!(name: "12% off 15 or more", quantity_threshold: 15, percentage: 0.12)
    @discount5 = @merchant2.bulk_discounts.create!(name: "17% off 25 or more", quantity_threshold: 25, percentage: 0.17)
    @discount6 = @merchant2.bulk_discounts.create!(name: "23% off 35 or more", quantity_threshold: 35, percentage: 0.23)

    end

    describe "As a Merchant" do
        describe "When I visit my bulk discount show page" do
            it 'Shows that bulk discounts quantity threshold and percentage discount' do
                visit merchant_bulk_discount_path(@merchant1, @discount1)

                within "#discount_info" do
                    expect(page).to have_content("Discount: #{@discount1.name}")
                    expect(page).to have_content("Discount Threshold: #{@discount1.quantity_threshold}")
                    expect(page).to have_content("Discount Percentage: #{@discount1.percentage * 100}%")
                end
            end
        end
    end
end