require 'rails_helper'

RSpec.describe '/DELETE Sections', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:section) { create(:section, project: project) }
  let(:unauthorized_user) { create(:user) }

  context 'When user deletes section belonging to the user' do
    before do
      login_with_api(user)
      delete "/api/v1/sections/#{section.id}", headers: {
        Authorization: response.headers['Authorization']
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the deleted section' do
      expect(json['id']).to eq(section.id)
      expect(json['title']).to eq('Section')
    end

    it 'deletes the section' do
      expect(project.sections).not_to exist
    end
  end

  context 'When user tries to delete section not belonging to them' do
    before do
      login_with_api(unauthorized_user)
      delete "/api/v1/sections/#{section.id}", headers: {
        Authorization: response.headers['Authorization']
      }
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end

    it 'does not delete the project' do
      expect(project.sections).to exist
    end
  end

  context 'When the Authorization header is missing' do
    before do
      delete "/api/v1/sections/#{section.id}"
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end

    it 'does not delete the project' do
      expect(project.sections).to exist
    end
  end
end
