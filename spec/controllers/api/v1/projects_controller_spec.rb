require 'rails_helper'

RSpec.describe Api::V1::ProjectsController, type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }

  context 'When fetching a project' do
    before do
      login_with_api(user)
      get "/api/v1/projects/#{project.id}", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the user' do
      data = json
      expect(data['id']).to eq(project.id)
      expect(data['title']).to eq(project.title)
    end
  end

  context 'When a project is missing' do
    before do
      login_with_api(user)
      get '/api/v1/projects/blank', headers: {
        'Authorization': response.headers['Authorization']
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
