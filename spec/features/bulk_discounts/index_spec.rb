require "rails_helper"

RSpec.describe "Bulk Discounts Index", type: :feature do
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

    describe 'As a Merchant' do
        describe 'When I visit my bulk discounts index page' do
            it 'Shows all of my bulk discounts, percentage discount and quantity threshold and has a link to that discounts show page' do
                visit merchant_bulk_discounts_path(@merchant1)

                within "#discount_#{@discount1.id}" do
                    expect(page).to have_link("Bulk Discount :#{@discount1.name}")
                    expect(page).to have_content(@discount1.quantity_threshold)
                    expect(page).to have_content("#{@discount1.percentage * 100}%")
                end
                
                within "#discount_#{@discount2.id}" do
                    expect(page).to have_link("Bulk Discount :#{@discount2.name}")
                    expect(page).to have_content(@discount2.quantity_threshold)
                    expect(page).to have_content("#{@discount2.percentage * 100}%")
                end
                
                expect(page).to_not have_content("#discount_#{@discount4}")
                expect(page).to_not have_content("#discount_#{@discount5}")
                expect(page).to_not have_content("#discount_#{@discount6}")
            end

            it 'Has a link to create a new bulk discount' do
                visit merchant_bulk_discounts_path(@merchant1)

                expect(page).to have_link("Add Bulk Discount")

                click_link "Add Bulk Discount"

                expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1))

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

            it 'has a link to delete a bulk discount' do
                visit merchant_bulk_discounts_path(@merchant1)

                within "#discount_#{@discount1.id}" do

                    expect(page).to have_link("Bulk Discount :#{@discount1.name}")
                    expect(page).to have_content(@discount1.quantity_threshold)
                    expect(page).to have_content("#{@discount1.percentage * 100}%")
                    expect(page).to have_button("Delete Discount: #{@discount1.id}")

                    click_button "Delete Discount: #{@discount1.id}"
                end
                
                expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))

                expect(page).to_not have_content("#discount_#{@discount1.id}")
            end
        end
    end
end