require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:section) { create(:section, project: project) }
  let(:unauthorized_user) { create(:user) }

  context 'When user creates task for project that belongs to them' do
    before do
      login_with_api(user)
      post "/api/v1/projects/#{project.id}/tasks", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        task: {
          title: 'Test Task'
        }
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the task' do
      expect(json).to include(*Task.attribute_names)
    end

    it 'adds task to users project' do
      new_task_id = json['id']
      user_project_tasks = user.projects.first.tasks
      expect(user_project_tasks.ids).to include(new_task_id)
    end
  end

  context 'When user creates task for section that belongs to them' do
    before do
      login_with_api(user)
      post "/api/v1/sections/#{section.id}/tasks", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        task: {
          title: 'Test Task'
        }
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the task' do
      expect(json).to include(*Task.attribute_names)
    end

    it 'adds task to users project section' do
      new_task_id = json['id']
      user_section_tasks = user.projects.first.sections.first.tasks
      expect(user_section_tasks.ids).to include(new_task_id)
    end
  end

  context 'When user tries to create task for project that does not belong to them' do
    before do
      login_with_api(unauthorized_user)
      post "/api/v1/projects/#{project.id}/tasks", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        task: {
          title: 'Test Task'
        }
      }
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end
  end

  context 'When user tries to create task for section that does not belong to them' do
    before do
      login_with_api(unauthorized_user)
      post "/api/v1/sections/#{section.id}/tasks", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        task: {
          title: 'Test Task'
        }
      }
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end
  end

  context 'When user tries to create task for project that is missing' do
    before do
      login_with_api(user)
      post '/api/v1/projects/blank/tasks', headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        section: {
          title: 'Test Task'
        }
      }
    end

    it 'returns 404' do
      expect(response.status).to eq(404)
      expect(json).to include('errors')
    end
  end

  context 'When user tries to create task for section that is missing' do
    before do
      login_with_api(user)
      post '/api/v1/sections/blank/tasks', headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        section: {
          title: 'Test Task'
        }
      }
    end

    it 'returns 404' do
      expect(response.status).to eq(404)
      expect(json).to include('errors')
    end
  end

  context 'When the Authorization header is missing' do
    before do
      post "/api/v1/projects/#{project.id}/tasks", params: {
        section: {
          title: 'Test Task'
        }
      }
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end
  end
end
