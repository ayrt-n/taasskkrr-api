require 'rails_helper'

RSpec.describe 'TasksController#create', type: :request do
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

    it 'adds task to users project' do
      new_task_id = json['id']
      user_project_tasks = project.tasks
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

    it 'adds task to users project section' do
      new_task_id = json['id']
      user_section_tasks = section.tasks
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
      expect(json).to include('error')
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
      expect(json).to include('error')
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

RSpec.describe 'TasksController#update', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, user: user, taskable: project) }
  let(:unauthorized_user) { create(:user) }

  context 'When user edits task belonging to user' do
    before do
      login_with_api(user)
      patch "/api/v1/tasks/#{task.id}", headers: {
        'Authorization': response.headers['Authorization']
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
        'Authorization': response.headers['Authorization']
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
        'Authorization': response.headers['Authorization']
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

RSpec.describe 'TasksController#destroy', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, user: user, taskable: project) }
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