require 'rails_helper'

RSpec.describe 'Bulk Discount New Forum' do 
    before(:each) do
        @merchant1 = Merchant.create!(name: "Hair Care")
    end
    describe 'As a Merchant' do
        describe 'When I visit the new bulk discount page' do
            it 'Has a form and a button to create a new bulk discount' do
                visit new_merchant_bulk_discount_path(@merchant1)

                within "#discount_create" do

                    fill_in :name, with: "A New 15.5% off 12 items discount"
                    fill_in :quantity_threshold, with: 12
                    fill_in :percentage, with: 15.5
                
                    click_button "Submit"
                end

                expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))

                expect(page).to have_content("A New 15.5% off 12 items discount")
                expect(page).to have_content("Discount Quanitity Threshold: 12")
                expect(page).to have_content("Discount Percentage: 15.5%")
            end

            it 'Shows a flash message if fields not filled in' do

                visit new_merchant_bulk_discount_path(@merchant1)

                fill_in "Name", with: ""
                fill_in "Quantity", with: "15"
                fill_in "Percentage", with: "0.25"

                click_button "Submit"
                
                expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1))
                expect(page).to have_content("All fields must be completed.")
            end
        end
    end
end