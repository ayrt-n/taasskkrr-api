require 'rails_helper'

RSpec.describe '/GET Tasks', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  context 'When user is authorized' do
    before do
      # Freeze time to current day
      Timecop.freeze(Date.today)

      # Create number of tasks from users
      create(:task, project: user.inbox, due_date: Date.today + 1.day)
      create(:task, project: user.inbox, due_date: Date.today)
      create(:task, project: user.inbox, due_date: Date.today - 1.day)
      create(:task, project: user.inbox, due_date: Date.today + 3.day)

      3.times { create(:task, project: other_user.inbox) }

      # Login
      login_with_api(user)
    end

    after do
      # Unfreeze time
      Timecop.return
    end

    it 'returns all users tasks sorted by date' do
      get '/api/v1/tasks', headers: {
        Authorization: response.headers['Authorization']
      }

      due_dates = json['tasks'].map { |task| task['due_date'] }

      expect(json['tasks'].length).to eq(4)
      expect(due_dates).to eq(due_dates.sort)
    end

    it 'returns 200' do
      get '/api/v1/tasks', headers: {
        Authorization: response.headers['Authorization']
      }

      expect(response.status).to eq(200)
    end

    context 'when querying for todays tasks' do
      it 'returns only tasks from today' do
        get '/api/v1/tasks', headers: {
          Authorization: response.headers['Authorization']
        }, params: {
          today: true
        }

        task_dates = json['tasks'].map { |task| task['due_date'].to_date }
                                  .uniq

        expect(task_dates.length).to eq(1)
        expect(task_dates[0]).to eq(Date.today)
      end
    end
  end

  context 'When user is not authorized' do
    it 'returns 401' do
      get '/api/v1/tasks'
      expect(response.status).to eq(401)
    end
  end
end
