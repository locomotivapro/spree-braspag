require "spec_helper"

describe Spree::CheckoutHelper do

  context "#payment_parcels_array" do

    context "for a minimun value of 50.25 and a max of 3 parcels" do
      it "should return one record for an 30 order" do
        helper.payment_parcels_array(30, 3, 50.25).should eq [['1x de $30.00', "1"]]
      end

      it "should return one record for an 60 order" do
        helper.payment_parcels_array(60, 3, 50.25).should eq [['1x de $60.00', "1"]]
      end

      it "should return two records for an 100.50 order" do
        helper.payment_parcels_array(100.50, 3, 50.25).should eq [["1x de $100.50", "1"], ["2x de $50.25", "2"]]
      end

      it "should return two records for an 110.00 order" do
        helper.payment_parcels_array(110.0, 3, 50.25).should eq [["1x de $110.00", "1"], ["2x de $55.00", "2"]]
      end

      it "should return three records for an 400 order" do
        helper.payment_parcels_array(400.0, 3, 50.25).should eq [["1x de $400.00", "1"], ["2x de $200.00", "2"], ["3x de $133.33", "3"]]
      end
    end

    context "for a minimun value of 50.25 and a max of 1 parcel" do
      it "should return one record for an 30 order" do
        helper.payment_parcels_array(30, 1, 50.25).should eq [['1x de $30.00', "1"]]
      end

      it "should return one record for an 60 order" do
        helper.payment_parcels_array(60, 1, 50.25).should eq [['1x de $60.00', "1"]]
      end

      it "should return one record for an 100.50 order" do
        helper.payment_parcels_array(100.50, 1, 50.25).should eq [["1x de $100.50", "1"]]
      end

      it "should return one record for an 110.00 order" do
        helper.payment_parcels_array(110.0, 1, 50.25).should eq [["1x de $110.00", "1"]]
      end

      it "should return one record for an 400 order" do
        helper.payment_parcels_array(400.0, 1, 50.25).should eq [["1x de $400.00", "1"]]
      end
    end

  end

end
