require 'rails_helper'

RSpec.describe '/PATCH Tasks', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project) }
  let(:unauthorized_user) { create(:user) }

  context 'When user edits task belonging to user' do
    before do
      login_with_api(user)
      patch "/api/v1/tasks/#{task.id}", headers: {
        Authorization: response.headers['Authorization']
      }, params: {
        task: {
          title: 'Updated task'
        }
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the updated task' do
      expect(json['id']).to eq(task.id)
      expect(json['title']).to eq('Updated task')
    end

    it 'updates the task' do
      task.reload
      expect(task.title).to eq('Updated task')
    end
  end

  context 'When user tries to edit task not belonging to user' do
    before do
      login_with_api(unauthorized_user)
      patch "/api/v1/tasks/#{task.id}", headers: {
        Authorization: response.headers['Authorization']
      }, params: {
        task: {
          title: 'Updated task'
        }
      }
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end

    it 'does not update the task' do
      task.reload
      expect(task.title).to eq('A simple task')
    end
  end

  context 'When task is missing' do
    before do
      login_with_api(user)
      patch '/api/v1/tasks/blank', headers: {
        Authorization: response.headers['Authorization']
      }, params: {
        task: {
          title: 'Updated task'
        }
      }
    end

    it 'returns 404' do
      expect(response.status).to eq(404)
    end
  end

  context 'When the Authorization header is missing' do
    before do
      patch "/api/v1/tasks/#{task.id}", params: {
        task: {
          title: 'Updated task'
        }
      }
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end

    it 'does not update the task' do
      task.reload
      expect(task.title).to eq('A simple task')
    end
  end
end
