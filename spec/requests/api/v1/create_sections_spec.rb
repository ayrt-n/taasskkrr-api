require 'rails_helper'

RSpec.describe '/POST Sections', type: :request do
  let(:user) { create(:user) }
  let(:unauthorized_user) { create(:user) }
  let(:project) { create(:project, user: user) }

  context 'when user creates section that belongs to them' do
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

  context 'when invalid parameters provided' do
    before do
      login_with_api(user)
      post "/api/v1/projects/#{project.id}/sections", headers: {
        Authorization: response.headers['Authorization']
      }, params: {
        section: {
          title: ''
        }
      }
    end

    it 'it returns a useful error message' do
      expect(json['error']['details'][0]).to eq("Title can't be blank")
    end

    it 'returns 422' do
      expect(response.status).to eq(422)
    end
  end

  context 'when user creates section for project that does not belong to them' do
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

  context 'when user tries to create section for project that is missing' do
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

  context 'when the Authorization header is missing' do
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
