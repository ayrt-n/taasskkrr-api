require 'rails_helper'

RSpec.describe '/GET Projects', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:unauthorized_user) { create(:user) }

  context 'When fetching a project that belongs to the user' do
    before do
      login_with_api(user)
      get "/api/v1/projects/#{project.id}", headers: {
        Authorization: response.headers['Authorization']
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the project' do
      expect(json['id']).to eq(project.id)
      expect(json['title']).to eq(project.title)
    end
  end

  context 'When fetching a project that does not belong to the user' do
    before do
      login_with_api(unauthorized_user)
      get "/api/v1/projects/#{project.id}", headers: {
        Authorization: response.headers['Authorization']
      }
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end
  end

  context 'When a project is missing' do
    before do
      login_with_api(user)
      get '/api/v1/projects/blank', headers: {
        Authorization: response.headers['Authorization']
      }
    end

    it 'returns 404' do
      expect(response.status).to eq(404)
    end
  end

  context 'When the Authorization header is missing' do
    before do
      get "/api/v1/projects/#{project.id}"
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end
  end
end
