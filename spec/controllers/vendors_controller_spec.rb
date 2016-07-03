require "rails_helper"

describe VendorsController do
  describe "POST #create" do
    it "creates a new Vendor" do
      post :create, :vendor => { :name => "test" }
      vendor = assigns(:vendor)

      expect(vendor.name).to eq("test")
    end

    it "redirects to the Vendor show route" do
      post :create, :vendor => { :name => "test" }
      expect(response).to redirect_to(vendor_path(assigns(:vendor)))
    end
  end

  describe "GET #index" do
    let(:vendor1) { ::Vendor.create! }
    let(:vendor2) { ::Vendor.create! }

    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns all Vendor records" do
      get :index
      expect(assigns(:vendors)).to match_array([vendor1, vendor2])
    end
  end

  describe "GET #show" do
    let(:vendor) { ::Vendor.create! }

    it "responds successfully with an HTTP 200 status code" do
      get :show, :id => vendor.id
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns the Vendor record" do
      get :show, :id => vendor.id
      expect(assigns(:vendor)).to match(vendor)
    end
  end
end