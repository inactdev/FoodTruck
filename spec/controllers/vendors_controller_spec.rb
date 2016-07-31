require "rails_helper"

describe VendorsController do
  describe "POST #create" do
    it "creates a new Vendor" do
      post :create, :vendor => { :name => "test" }
      vendor = assigns(:vendor)

      expect(vendor.name).to eq("test")
    end

    it "redirects to the Vendor show route when save is successful" do
      post :create, :vendor => { :name => "test" }

      expect(response).to redirect_to(vendor_path(assigns(:vendor)))
      expect(flash[:success]).to be_present
    end

    before { request.env["HTTP_REFERER"] = "Redirect back" }

    it "redirects back when save is unsuccessful" do
      allow_any_instance_of(::Vendor).to receive(:save).and_return(false)
      post :create, :vendor => { :name => "test" }

      expect(response).to redirect_to("Redirect back")
      expect(flash[:error]).to be_present
    end
  end

  describe "POST #destroy" do
    let(:vendor) { ::Vendor.create! }

    it "redirects to the Vendor show route when destroy is successful" do
      post :destroy, :id => vendor.id

      expect(assigns(:vendor).destroyed?).to be true
      expect(flash[:success]).to be_present
    end

    before { request.env["HTTP_REFERER"] = "Redirect back" }

    it "redirects back when destroy is unsuccessful" do
      allow_any_instance_of(::Vendor).to receive(:destroy).and_return(false)
      post :destroy, :id => vendor.id

      expect(response).to redirect_to("Redirect back")
      expect(flash[:error]).to be_present
    end
  end

  describe "GET #edit" do
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

  describe "GET #new" do
    it "responds successfully with an HTTP 200 code" do
      get :new
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "initializes a new Vendor object" do
      get :new
      expect(assigns(:vendor)).to be_a(::Vendor)
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

  describe "POST #update" do
    let(:vendor) { ::Vendor.create! }

    it "updates the Vendor" do
      post :update, :id => vendor.id, :vendor => { :name => "test" }
      vendor = assigns(:vendor)

      expect(vendor.name).to eq("test")
    end

    it "redirects to the Vendor show route when save is successful" do
      post :update, :id => vendor.id, :vendor => { :name => "test" }

      expect(response).to redirect_to(vendor_path(assigns(:vendor)))
      expect(flash[:success]).to be_present
    end

    before { request.env["HTTP_REFERER"] = "Redirect back" }

    it "redirects back when save is unsuccessful" do
      allow_any_instance_of(::Vendor).to receive(:save).and_return(false)
      post :create, :vendor => { :name => "test" }

      expect(response).to redirect_to("Redirect back")
      expect(flash[:error]).to be_present
    end
  end
end