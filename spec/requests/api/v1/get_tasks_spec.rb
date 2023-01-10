require 'rails_helper'

RSpec.describe '/GET Tasks', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  context 'When user is authorized' do
    before do
      3.times { create(:task, project: user.inbox) }
      3.times { create(:task, project: other_user.inbox) }

      login_with_api(user)
      get '/api/v1/tasks', headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns all users tasks' do
      expect(json['tasks'].length).to eq(3)
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end
  end

  context 'When user is not authorized' do
    it 'returns 401' do
      get '/api/v1/tasks'
      expect(response.status).to eq(401)
    end
  end
end
