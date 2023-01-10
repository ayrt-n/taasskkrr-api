require 'rails_helper'

RSpec.describe '/DELETE Projects', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:unauthorized_user) { create(:user) }

  context 'When user deletes project belonging to the user' do
    before do
      login_with_api(user)
      delete "/api/v1/projects/#{project.id}", headers: {
        Authorization: response.headers['Authorization']
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the deleted project' do
      expect(json['id']).to eq(project.id)
      expect(json['title']).to eq(project.title)
    end

    it 'deletes the project' do
      expect(user.projects).not_to include(project)
    end
  end

  context 'When user tries to delete project not belonging to them' do
    before do
      login_with_api(unauthorized_user)
      delete "/api/v1/projects/#{project.id}", headers: {
        Authorization: response.headers['Authorization']
      }
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end

    it 'does not delete the project' do
      expect(user.projects).to exist
    end
  end

  context 'When user tries to delete default inbox project' do
    before do
      login_with_api(user)
      delete "/api/v1/projects/#{user.inbox.id}", headers: {
        Authorization: response.headers['Authorization']
      }
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end

    it 'does not delete the project' do
      expect(user.inbox).not_to be_nil
    end
  end

  context 'When the Authorization header is missing' do
    before do
      delete "/api/v1/projects/#{project.id}"
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end

    it 'does not delete project' do
      expect(user.projects).to exist
    end
  end
end
