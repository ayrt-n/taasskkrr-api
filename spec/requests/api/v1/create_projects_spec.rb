require 'rails_helper'

RSpec.describe '/POST Projects', type: :request do
  let(:user) { create(:user) }

  context 'when user is authorized' do
    before do
      login_with_api(user)
      post '/api/v1/projects', headers: {
        Authorization: response.headers['Authorization']
      }, params: {
        project: {
          title: 'Test Project'
        }
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the newly created project' do
      user_project = user.projects.last

      expect(json['id']).to eq(user_project.id)
      expect(json['title']).to eq(user_project.title)
    end
  end

  context 'when invalid parameters provided' do
    before do
      login_with_api(user)
      post '/api/v1/projects', headers: {
        Authorization: response.headers['Authorization']
      }, params: {
        project: {
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

  context 'when user is not authorized' do
    it 'returns 401' do
      post '/api/v1/projects'
      expect(response.status).to eq(401)
    end
  end
end
