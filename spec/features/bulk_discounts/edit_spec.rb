require "rails_helper"

describe "Bulk Discounts Edit Page" do
    before :each do
        @merchant1 = Merchant.create!(name: "Hair Care")
        @merchant2 = Merchant.create!(name: "Strickland Propane")
    
        @discount1 = @merchant1.bulk_discounts.create!(name: "10% off 10 or more", quantity_threshold: 10, percentage: 0.10)
        @discount2 = @merchant1.bulk_discounts.create!(name: "15% off 20 or more", quantity_threshold: 20, percentage: 0.15)
        @discount3 = @merchant1.bulk_discounts.create!(name: "20% off 30 or more", quantity_threshold: 30, percentage: 0.20)
    
        @discount4 = @merchant2.bulk_discounts.create!(name: "12% off 15 or more", quantity_threshold: 15, percentage: 0.12)
        @discount5 = @merchant2.bulk_discounts.create!(name: "17% off 25 or more", quantity_threshold: 25, percentage: 0.17)
        @discount6 = @merchant2.bulk_discounts.create!(name: "23% off 35 or more", quantity_threshold: 35, percentage: 0.23)
    end

    it "sees a form filled in with the items attributes" do
        visit edit_merchant_bulk_discount_path(@merchant1, @discount1)

        expect(find_field("Name").value).to eq(@discount1.name)
        expect(find_field("Quantity").value).to eq("#{@discount1.quantity_threshold}")
        expect(find_field("Percentage").value).to eq("#{@discount1.percentage}")

        expect(find_field("Name").value).to_not eq(@discount2.name)
    end

    it "can fill in form, click submit, and redirect to that item's show page and see updated info and flash message" do
        visit edit_merchant_bulk_discount_path(@merchant1, @discount1)

        fill_in "Name", with: "13% off 27 or more"
        fill_in "Quantity", with: "27"
        fill_in "Percentage", with: "0.13"

        click_button "Submit"

        expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @discount1))
        expect(page).to have_content("13% off 27 or more")
        expect(page).to have_content("27")
        expect(page).to have_content("13%")
        # expect(page).to have_content("Succesfully Updated Item Info!")
    end

    xit "shows a flash message if not all sections are filled in" do
        visit edit_merchant_bulk_discount_path(@merchant1, @discount1)

        fill_in "Name", with: ""
        fill_in "Description", with: "Eco friendly shampoo"
        fill_in "Unit price", with: "15"

        click_button "Submit"
        
        expect(current_path).to eq(edit_merchant_item_path(@merchant1, @discount1))
        expect(page).to have_content("All fields must be completed, get your act together.")
    end
end
