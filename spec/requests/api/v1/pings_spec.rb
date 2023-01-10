require 'rails_helper'

RSpec.describe 'Pings#Ping', type: :request do
  it 'returns 200' do
    get '/api/v1/ping'
    expect(response.status).to eq(200)
  end
end
