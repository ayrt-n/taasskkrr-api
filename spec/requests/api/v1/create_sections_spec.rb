require 'rails_helper'

RSpec.describe '/GET Sections', type: :request do
  let(:user) { create(:user) }
  let(:unauthorized_user) { create(:user) }
  let(:project) { create(:project, user: user) }

  context 'When user creates section that belongs to them' do
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

    it 'returns the newly created section' do
      user_section = project.sections.last
      expect(json['id']).to eq(user_section.id)
      expect(json['title']).to eq(user_section.title)
    end
  end

  context 'When user creates section for project that does not belong to them' do
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
    end
  end

  context 'When user tries to create section for project that is missing' do
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
    end
  end
end
