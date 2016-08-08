require "rails_helper"

describe ::Api::V1::OwnersController do
  let(:good_creds) {
    {
      :name => "test",
      :email => "test@me.com",
      :password => "123456",
      :password_confirmation => "123456"
    }
  }

  describe "POST #create" do
    context "with good credentials" do
      it "creates a new owner" do
        post :create, :owner => good_creds
        owner = assigns(:owner)

        expect(owner.name).to eq(good_creds[:name])
        expect(owner.email).to eq(good_creds[:email])
      end

      it "renders access_token and 201 status when save is successful" do
        post :create, :owner => good_creds

        owner = ::Owner.by_email(good_creds[:email]).first
        expect(response.body).to eq(owner.access_token)
        expect(response).to have_http_status(201)
      end
    end

    context "with bad credentials" do
      it "renders errors and 422 status when save is unsuccessful" do
        post :create, :owner => { :name => "test" }

        expect(JSON.parse(response.body)["email"]).to include("is invalid")
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "POST #destroy" do
    let(:owner) { ::Owner.create!(good_creds) }

    it "renders successful message and 200 status when destroy is successful" do
      post :destroy, :id => owner.id, :access_token => owner.access_token

      expect(assigns(:owner).destroyed?).to be true
      expect(response.body).to eq("Owner deleted successfully")
      expect(response).to have_http_status(200)
    end

    it "renders unsuccessful message and 422 status when destroy is successful" do
      allow_any_instance_of(::Owner).to receive(:destroy).and_return(false)
      post :destroy, :id => owner.id, :access_token => owner.access_token

      expect(assigns(:owner).destroyed?).to be false
      expect(response.body).to eq("Owner could not be deleted :o/")
      expect(response).to have_http_status(422)
    end
  end

  describe "GET #edit" do
    let(:owner) { ::Owner.create!(good_creds) }

    it "renders successful message and 200 status when destroy is successful" do
      post :destroy, :id => owner.id, :access_token => owner.access_token

      expect(assigns(:owner)).to eq(owner)
      expect(response).to have_http_status(200)
    end

    it "renders unsuccessful message and 422 status when destroy is successful" do
      allow(::Owner).to receive(:by_access_token).and_return([])
      post :edit, :id => owner.id, :access_token => owner.access_token

      expect(assigns(:owner)).to eq(nil)
      expect(response.body).to eq("Could not find Owner")
      expect(response).to have_http_status(422)
    end
  end

  describe "GET #index" do
    it "returns all Owner records and responds successfully with an HTTP 200 status code" do
      owner = ::Owner.create!(good_creds)
      get :index

      expect(assigns(:owners)).to match_array([owner])
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #new" do
    it "responds successfully with an HTTP 200 code" do
      get :new

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "initializes a new Owner object" do
      get :new

      expect(assigns(:owner)).to be_a(::Owner)
    end
  end

  describe "GET #show" do
    let(:owner) { ::Owner.create!(good_creds) }

    it "returns the Owner record and responds successfully with an HTTP 200 status code when Owner is found" do
      post :show, :id => owner.id, :access_token => owner.access_token

      expect(assigns(:owner)).to match(owner)
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns the Owner record and responds successfully with an HTTP 200 status code when Owner is found" do
      allow(::Owner).to receive(:by_access_token).and_return([])
      post :show, :id => owner.id, :access_token => owner.access_token

      expect(assigns(:owner)).to eq(nil)
      expect(response.body).to eq("Could not find Owner")
      expect(response).to have_http_status(422)
    end
  end

  describe "POST #update" do
    let(:owner) { ::Owner.create!(good_creds) }

    it "renders successful message and 200 status when update is successful" do
      post :update, :id => owner.id, :access_token => owner.access_token, :owner => { :email => "test2@me.com", :password => 123456 }

      expect(assigns(:owner).email).to eq("test2@me.com")
      expect(response.body).to eq("Owner updated successfully")
      expect(response).to have_http_status(200)
    end

    it "renders unsuccessful message and 422 status when update is successful" do
      post :update, :id => owner.id, :access_token => owner.access_token, :owner => { :email => "test2@" }

      expect(owner.email).to eq(good_creds[:email])
      expect(response.body).to eq("Owner could not be updated :o/")
      expect(response).to have_http_status(422)
    end
  end
end