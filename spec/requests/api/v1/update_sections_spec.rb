require 'rails_helper'

RSpec.describe '/PATCH Sections', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:section) { create(:section, project: project) }
  let(:unauthorized_user) { create(:user) }

  context 'When user edits section belonging to the user' do
    before do
      login_with_api(user)
      patch "/api/v1/sections/#{section.id}", headers: {
        Authorization: response.headers['Authorization']
      }, params: {
        section: {
          title: 'Updated Section'
        }
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the updated section' do
      section.reload
      expect(json['id']).to eq(section.id)
      expect(json['title']).to eq('Updated Section')
    end

    it 'updates the section title' do
      section.reload
      expect(section.title).to eq('Updated Section')
    end
  end

  context 'When user tries to update section not belonging to them' do
    before do
      login_with_api(unauthorized_user)
      patch "/api/v1/sections/#{section.id}", headers: {
        Authorization: response.headers['Authorization']
      }, params: {
        section: {
          title: 'Updated Section'
        }
      }
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end

    it 'does not change the section title' do
      section.reload
      expect(section.title).to eq('Section')
    end
  end

  context 'When the section is missing' do
    before do
      login_with_api(user)
      patch "/api/v1/sections/blank", headers: {
        Authorization: response.headers['Authorization']
      }, params: {
        section: {
          title: 'Updated Section'
        }
      }
    end

    it 'returns 404' do
      expect(response.status).to eq(404)
    end
  end

  context 'When the Authorization header is missing' do
    before do
      patch "/api/v1/sections/#{section.id}", params: {
        section: {
          title: 'Updated Section'
        }
      }
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end
  end
end
