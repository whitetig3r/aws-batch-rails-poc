require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
  describe 'GET /todos' do
    it 'returns a list of todos' do
      get('/todos')
      json = JSON.parse(response.body)
      expect(json['status']).to eql('ok')
    end
  end
end