require 'rails_helper'

RSpec.describe 'Pings', type: :request do
  context '/GET Ping' do
    it 'returns 200' do
      get '/api/v1/ping'
      expect(response.status).to eq(200)
    end
  end
end
