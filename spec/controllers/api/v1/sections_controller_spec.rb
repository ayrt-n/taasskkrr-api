require 'rails_helper'

RSpec.describe 'SectionsController#Show', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:unauthorized_user) { create(:user) }

  context 'When creating a section in a project that belongs to the user' do
    before do
      login_with_api(user)
      post "/api/v1/projects/#{project.id}/sections", headers: {
        'Authorization': response.headers['Authorization']
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
        'Authorization': response.headers['Authorization']
      }, params: {
        section: {
          title: 'Test Section'
        }
      }
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
      expect(json).to include('errors')
    end
  end

  context 'When a project is missing' do
    before do
      login_with_api(user)
      post '/api/v1/projects/blank/sections', headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        section: {
          title: 'Test Section'
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
      post "/api/v1/projects/#{project.id}/sections", params: {
        section: {
          title: 'Test Section'
        }
      }
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
      # expect(json).to include('errors')
    end
  end
end

RSpec.describe 'SectionsController#Update', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:section) { create(:section, project: project) }
  let(:unauthorized_user) { create(:user) }

  context 'When user edits section belonging to the user' do
    before do
      login_with_api(user)
      patch "/api/v1/sections/#{section.id}", headers: {
        'Authorization': response.headers['Authorization']
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
        'Authorization': response.headers['Authorization']
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
        'Authorization': response.headers['Authorization']
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

RSpec.describe 'SectionsController#Destroy', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:section) { create(:section, project: project) }
  let(:unauthorized_user) { create(:user) }

  context 'When user deletes section belonging to the user' do
    before do
      login_with_api(user)
      delete "/api/v1/sections/#{section.id}", headers: {
        'Authorization': response.headers['Authorization']
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
        'Authorization': response.headers['Authorization']
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
