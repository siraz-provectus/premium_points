require "rails_helper"

describe 'Balances', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:user2) { FactoryBot.create(:user) }
  let!(:user3) { FactoryBot.create(:user) }

  describe 'Index without params' do
    before(:each) {
      get api_v1_balances_path, { headers: {'HTTP_ACCEPT' => "application/json"} }
      @body = JSON.parse response.body
    }

    it 'response should be success' do
      expect(response).to be_successful
    end

    it 'status should be 200' do
      expect(response.status).to be(200)
    end

    it 'response body should contain 3 balances' do
      expect(@body.count).to eq(3)
    end

    it 'response first user should contain fields' do
      expect(@body[0]).to include("id")
      expect(@body[0]).to include("sum")
      expect(@body[0]).to include("user_name")
    end

    it 'response first balance should contain user_name' do
      expect(@body[0]['user_name']).to eq("#{user.first_name} #{user.last_name}")
    end
  end

  describe 'Index with page=2 page_size=1' do
    before(:each) {
      get api_v1_balances_path, { params: {page:2, page_size: 1}, headers: {'HTTP_ACCEPT' => "application/json"} }
      @body = JSON.parse response.body
    }

    it 'response should be success' do
      expect(response).to be_successful
    end

    it 'status should be 200' do
      expect(response.status).to be(200)
    end

    it 'response body should contain 1 balances' do
      expect(@body.count).to eq(1)
    end

    it 'response first user should contain fields' do
      expect(@body[0]).to include("id")
      expect(@body[0]).to include("sum")
      expect(@body[0]).to include("user_name")
    end

    it 'response first balance should contain user_name' do
      expect(@body[0]['user_name']).to eq("#{user2.first_name} #{user2.last_name}")
    end
  end
end