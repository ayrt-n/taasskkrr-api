require 'rails_helper'

RSpec.describe Api::V1::RegistrationsController, type: :request do
  let(:user) { build(:user) }
  let(:existing_user) { create(:user) }
  let(:signup_url) { '/api/v1/signup' }

  context 'When creating a new user' do
    before do
      post signup_url, params: {
        user: {
          email: user.email,
          password: user.password
        }
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the user email' do
      expect(json).to have_key('email')
      expect(json['email']).to eq(user.email)
    end
  end

  context 'When an email already exists' do
    before do
      post signup_url, params: {
        user: {
          email: existing_user.email,
          password: existing_user.password
        }
      }
    end

    it 'returns 422' do
      expect(response.status).to eq(422)
    end
  end
end
