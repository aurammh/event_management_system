require 'rails_helper'

RSpec.describe Api::V1::EventsController, type: :request do
  
  describe "GET /api/v1/events" do
    it "returns a list of active events" do
      FactoryBot.create_list(:event, 3, active: true)
      FactoryBot.create(:event, active: false)
      
      user = FactoryBot.create(:user)
      token = user.device_token
      headers = { "Authorization" => "Bearer #{token}" }

      get "/api/v1/events", headers: headers

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq("application/json; charset=utf-8")

      events = JSON.parse(response.body)
      expect(events.length).to eq(3)
    end
  end

  describe "POST /api/v1/events" do
    it "creates a new event" do
      user = FactoryBot.create(:user)
      event_params = FactoryBot.attributes_for(:event)

      post "/api/v1/events", params: { event: event_params }, headers: { "Authorization" => "Bearer #{user.device_token}" }

      expect(response).to have_http_status(:created)
      expect(response.content_type).to eq("application/json; charset=utf-8")

      event = JSON.parse(response.body)
      expect(event["name"]).to eq(event_params[:name])
      expect(event["active"]).to be_truthy
    end

    it "returns unprocessable entity if event creation fails" do
      user = FactoryBot.create(:user)
      invalid_event_params = FactoryBot.attributes_for(:event, name: nil)

      post "/api/v1/events", params: { event: invalid_event_params }, headers: { "Authorization" => "Bearer #{user.device_token}" }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.content_type).to eq("application/json; charset=utf-8")

      errors = JSON.parse(response.body)
      expect(errors).to include("name")
    end
  end

  describe "PUT /api/v1/events/:id" do
    it "updates an existing event" do
      user = FactoryBot.create(:user)
      event = FactoryBot.create(:event, creator: user)
      updated_name = "Updated Event Name"

      put "/api/v1/events/#{event.id}", params: { event: { name: updated_name } }, headers: { "Authorization" => "Bearer #{user.device_token}" }

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq("application/json; charset=utf-8")

      updated_event = JSON.parse(response.body)
      expect(updated_event["name"]).to eq(updated_name)
    end

    it "returns unprocessable entity if event update fails" do
      user = FactoryBot.create(:user)
      event = FactoryBot.create(:event, creator: user)
      invalid_event_params = FactoryBot.attributes_for(:event, name: nil)

      put "/api/v1/events/#{event.id}", params: { event: invalid_event_params }, headers: { "Authorization" => "Bearer #{user.device_token}" }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.content_type).to eq("application/json; charset=utf-8")

      errors = JSON.parse(response.body)
      expect(errors).to include("name")
    end
  end

  describe "DELETE /api/v1/events/:id" do
    it "deletes an active event" do
      user = FactoryBot.create(:user)
      event = FactoryBot.create(:event, creator: user, active: true)

      delete "/api/v1/events/#{event.id}", headers: { "Authorization" => "Bearer #{user.device_token}" }

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(Event.exists?(event.id)).to be_falsey
    end

    it "returns an error if trying to delete a deactive event" do
      user = FactoryBot.create(:user)
      event = FactoryBot.create(:event, creator: user, active: false)

      delete "/api/v1/events/#{event.id}", headers: { "Authorization" => "Bearer #{user.device_token}" }

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(JSON.parse(response.body)).to include("error" => "Couldn't delete inactive event")
      expect(Event.exists?(event.id)).to be_truthy
    end
  end
end