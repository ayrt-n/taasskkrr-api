require 'rails_helper'

RSpec.describe '/GET Sections', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:unauthorized_user) { create(:user) }

  context 'When creating a section in a project that belongs to the user' do
    before do
      login_with_api(user)
      post "/api/v1/projects/#{project.id}/sections", headers: {
        Authorization: response.headers['Authorization']
      }, params: {
        section: {
          title: 'Test Section'
        }
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the new section' do
      expect(json['title']).to eq('Test Section')
      expect(json.keys).to include('id', 'title')
    end
  end

  context 'When creating a section in a project that does not belong to user' do
    before do
      login_with_api(unauthorized_user)
      post "/api/v1/projects/#{project.id}/sections", headers: {
        Authorization: response.headers['Authorization']
      }, params: {
        section: {
          title: 'Test Section'
        }
      }
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
      expect(json).to include('error')
    end
  end

  context 'When a project is missing' do
    before do
      login_with_api(user)
      post '/api/v1/projects/blank/sections', headers: {
        Authorization: response.headers['Authorization']
      }, params: {
        section: {
          title: 'Test Section'
        }
      }
    end

    it 'returns 404' do
      expect(response.status).to eq(404)
      expect(json).to include('error')
    end
  end

  context 'When the Authorization header is missing' do
    before do
      post "/api/v1/projects/#{project.id}/sections", params: {
        section: {
          title: 'Test Section'
        }
      }
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
      expect(json).to include('error')
    end
  end
end
