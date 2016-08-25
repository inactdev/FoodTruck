require "rails_helper"

describe ::Api::V1::VendorsController do
  describe "POST #create" do
    it "creates a new Vendor" do
      post :create, :vendor => { :name => "test" }
      vendor = assigns(:vendor)

      expect(vendor.name).to eq("test")
    end

    it "redirects to the Vendor show route when save is successful" do
      post :create, :vendor => { :name => "test" }

      expect(response).to redirect_to(vendor_path(assigns(:vendor)))
    end

    before { request.env["HTTP_REFERER"] = "Redirect back" }

    it "redirects back when save is unsuccessful" do
      allow_any_instance_of(::Vendor).to receive(:save).and_return(false)
      post :create, :vendor => { :name => "test" }

      expect(response).to redirect_to("Redirect back")
    end
  end

  describe "POST #destroy" do
    let(:vendor) { ::Vendor.create! }

    it "redirects to the Vendor show route when destroy is successful" do
      post :destroy, :id => vendor.id

      expect(assigns(:vendor).destroyed?).to be true
    end

    before { request.env["HTTP_REFERER"] = "Redirect back" }

    it "redirects back when destroy is unsuccessful" do
      allow_any_instance_of(::Vendor).to receive(:destroy).and_return(false)
      post :destroy, :id => vendor.id

      expect(response).to redirect_to("Redirect back")
    end
  end

  describe "GET #edit" do
    let(:vendor) { ::Vendor.create! }

    it "responds successfully with an HTTP 200 status code" do
      get :edit, :id => vendor.id
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns the Vendor record" do
      get :edit, :id => vendor.id
      expect(assigns(:vendor)).to match(vendor)
    end
  end

  describe "GET #index" do
    let!(:vendor1) { ::Vendor.create!(:name => "Ari", :latitude => 40.429721, :longitude => -111.8920836) }
    let!(:vendor2) { ::Vendor.create!(:name => "Tamra", :food_type => "Dominican", :latitude => 40.385039, :longitude => -111.885247) }
    let!(:vendor3) { ::Vendor.create!(:latitude => 40.830059, :longitude => -73.877286) }

    context "when no coordinates are provided" do
      it "returns We don't know where you are message" do
        get :index

        expect(response.body).to eq("We don't know where you are")
      end
    end

    context "when coordinates are provided" do
      it "responds successfully with an HTTP 200 status code" do
        get :index, :search => { :latitude => 40.386386, :longitude => -111.881778 }
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "by default returns all Vendor records within 5 miles" do
        get :index, :search => { :latitude => 40.386386, :longitude => -111.881778 }
        expect(assigns(:vendors)).to match_array([vendor1, vendor2])
      end

      context "should search" do
        it "by distance" do
          # search by huge radius to return all records
          get :index, :search => { :distance => 3000, :latitude => 40.386386, :longitude => -111.881778}
          expect(assigns(:vendors)).to match_array([vendor1, vendor2, vendor3])
        end

        it "by name" do
          get :index, :search => { :latitude => 40.386386, :longitude => -111.881778, :name => "Ari" }
          expect(assigns(:vendors)).to match_array([vendor1])
        end

        it "by food_type" do
          get :index, :search => { :latitude => 40.386386, :longitude => -111.881778, :food_type => "Dominican" }
          expect(assigns(:vendors)).to match_array([vendor2])
        end
      end

      context "when bounds are provided" do
        it "returns an empty array when it finds no vendors within bounds" do
          get :index, :search =>{:southwestPoint => [-2.500082474182407,-2.7924880947029465], :northeastPoint => [2.3133981059400677,2.7924880947029465]}
          expect(assigns(:vendors)).to match_array([])
        end

        it "returns vendors if they are within the bounds" do
          get :index, :search =>{:southwestPoint => [38.83426108295464, -113.4888920190281], :northeastPoint => [41.433909845677945, -109.5446812982527]}
          expect(assigns(:vendors)).to match_array([vendor1, vendor2])
        end
      end
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
    end

    before { request.env["HTTP_REFERER"] = "Redirect back" }

    it "redirects back when save is unsuccessful" do
      allow_any_instance_of(::Vendor).to receive(:save).and_return(false)
      post :create, :vendor => { :name => "test" }

      expect(response).to redirect_to("Redirect back")
    end
  end
end