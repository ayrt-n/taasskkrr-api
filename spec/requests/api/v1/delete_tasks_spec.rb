require 'rails_helper'

RSpec.describe '/DELETE Tasks', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project) }
  let(:unauthorized_user) { create(:user) }

  context 'When user deletes project belonging to user' do
    before do
      login_with_api(user)
      delete "/api/v1/tasks/#{task.id}", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'deletes the task' do
      expect(project.tasks).not_to exist
    end
  end

  context 'When user tries to delete project not belonging to them' do
    before do
      login_with_api(unauthorized_user)
      delete "/api/v1/tasks/#{task.id}", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end

    it 'does not delete task' do
      expect(project.tasks).to exist
    end
  end

  context 'When the Authorization header is missing' do
    before do
      delete "/api/v1/tasks/#{task.id}"
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end

    it 'does not delete task' do
      expect(project.tasks).to exist
    end
  end
end
