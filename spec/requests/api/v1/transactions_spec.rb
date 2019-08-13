require "rails_helper"

describe 'Transactions', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:user2) { FactoryBot.create(:user) }

  let!(:transaction)  { FactoryBot.create(:transaction, user: user) }
  let!(:transaction2) { FactoryBot.create(:transaction, user: user) }
  let!(:transaction3) { FactoryBot.create(:transaction, user: user, transaction_type: 'withdrawal') }
  let!(:transaction4) { FactoryBot.create(:transaction, user: user2) }
  let!(:transaction5) { FactoryBot.create(:transaction, user: user2, transaction_type: 'withdrawal') }

  describe 'Index without params' do
    before(:each) {
      get api_v1_transactions_path, { headers: {'HTTP_ACCEPT' => "application/json"} }
      @body = JSON.parse response.body
    }

    it 'response should be success' do
      expect(response).to be_successful
    end

    it 'status should be 200' do
      expect(response.status).to be(200)
    end

    it 'response body should contain 5 transactions' do
      expect(@body.count).to eq(5)
    end

    it 'response first transaction should contain fields' do
      expect(@body[0]).to include("id")
      expect(@body[0]).to include("sum")
      expect(@body[0]).to include("transaction_type")
      expect(@body[0]).to include("date")
      expect(@body[0]).to include("user_name")
    end

    it 'response first transaction should contain user_name' do
      expect(@body[0]['user_name']).to eq("#{transaction.user_first_name} #{transaction.user_last_name}")
    end

    it 'response first transaction should contain transaction_type' do
      expect(@body[0]['transaction_type']).to eq("replenishment")
    end

    it 'response first transaction should contain sum' do
      expect(@body[0]['sum']).to eq(100)
    end
  end

  describe 'Index with page=2 page_size=3' do
    before(:each) {
      get api_v1_transactions_path, { params: {page:2, page_size: 3}, headers: {'HTTP_ACCEPT' => "application/json"} }
      @body = JSON.parse response.body
    }

    it 'response should be success' do
      expect(response).to be_successful
    end

    it 'status should be 200' do
      expect(response.status).to be(200)
    end

    it 'response body should contain 2 transactions' do
      expect(@body.count).to eq(2)
    end

    it 'response first transaction should contain fields' do
      expect(@body[0]).to include("id")
      expect(@body[0]).to include("sum")
      expect(@body[0]).to include("transaction_type")
      expect(@body[0]).to include("date")
      expect(@body[0]).to include("user_name")
    end

    it 'response first transaction should contain user_name' do
      expect(@body[0]['user_name']).to eq("#{transaction4.user_first_name} #{transaction4.user_last_name}")
    end

    it 'response first transaction should contain transaction_type' do
      expect(@body[0]['transaction_type']).to eq("replenishment")
    end

    it 'response first transaction should contain sum' do
      expect(@body[0]['sum']).to eq(100)
    end
  end

  describe 'Index with page=2 page_size=2 user_id ' do
    before(:each) {
      get api_v1_transactions_path, { params: {page:2, page_size: 2, search: { user_id: user.id} }, headers: {'HTTP_ACCEPT' => "application/json"} }
      @body = JSON.parse response.body
    }

    it 'response should be success' do
      expect(response).to be_successful
    end

    it 'status should be 200' do
      expect(response.status).to be(200)
    end

    it 'response body should contain 1 transactions' do
      expect(@body.count).to eq(1)
    end

    it 'response first transaction should contain fields' do
      expect(@body[0]).to include("id")
      expect(@body[0]).to include("sum")
      expect(@body[0]).to include("transaction_type")
      expect(@body[0]).to include("date")
      expect(@body[0]).to include("user_name")
    end

    it 'response first transaction should contain user_name' do
      expect(@body[0]['user_name']).to eq("#{transaction3.user_first_name} #{transaction3.user_last_name}")
    end

    it 'response first transaction should contain transaction_type' do
      expect(@body[0]['transaction_type']).to eq("withdrawal")
    end

    it 'response first transaction should contain sum' do
      expect(@body[0]['sum']).to eq(100)
    end
  end

  describe 'Index with not_exited user_id ' do
    before(:each) {
      get api_v1_transactions_path, { params: {search: { user_id: User.last.id + 1} }, headers: {'HTTP_ACCEPT' => "application/json"} }
      @body = JSON.parse response.body
    }

    it 'response should be success' do
      expect(response).to be_successful
    end

    it 'status should be 200' do
      expect(response.status).to be(200)
    end

    it 'response body should contain 0 transactions' do
      expect(@body.count).to eq(0)
    end
  end

  describe 'Show' do
    before(:each) {
      get api_v1_transaction_path(transaction2), { headers: {'HTTP_ACCEPT' => "application/json"} }
      @body = JSON.parse response.body
    }

    it 'response should be success' do
      expect(response).to be_successful
    end

    it 'status should be 200' do
      expect(response.status).to be(200)
    end

    it 'response should contain fields' do
      expect(@body).to include("id")
      expect(@body).to include("sum")
      expect(@body).to include("transaction_type")
      expect(@body).to include("date")
      expect(@body).to include("user_name")
    end

    it 'response should contain user_name' do
      expect(@body['user_name']).to eq("#{transaction2.user_first_name} #{transaction2.user_last_name}")
    end

    it 'response should contain transaction_type' do
      expect(@body['transaction_type']).to eq("replenishment")
    end

    it 'response first transaction should contain sum' do
      expect(@body['sum']).to eq(100)
    end
  end

  describe 'Show with not exited row' do
    before(:each) {
      get api_v1_transaction_path(1000), { headers: {'HTTP_ACCEPT' => "application/json"} }
      @body = JSON.parse response.body
    }

    it 'response should not be success' do
      expect(response).to_not be_successful
    end

    it 'status should be 404' do
      expect(response.status).to be(404)
    end

    it 'response should contain error message' do
      expect(@body['error']['messages']).to eq(["Couldn't find Transaction with 'id'=1000"])
    end
  end

  describe 'Create success' do
    before(:each) {
      transaction_params = {
        user_id: user.id,
        transaction_type: 'replenishment',
        sum: 1000
      }

      post api_v1_transactions_path, { params: transaction_params, headers: {'HTTP_ACCEPT' => "application/json"} }
      @body = JSON.parse response.body
    }

    it 'response should be success' do
      expect(response).to be_successful
    end

    it 'status should be 200' do
      expect(response.status).to be(200)
    end

    it 'response should contain fields' do
      expect(@body).to include("id")
      expect(@body).to include("sum")
      expect(@body).to include("transaction_type")
      expect(@body).to include("date")
      expect(@body).to include("user_name")
    end

    it 'response should contain user_name' do
      expect(@body['user_name']).to eq("#{user.first_name} #{user.last_name}")
    end

    it 'response should contain transaction_type' do
      expect(@body['transaction_type']).to eq("replenishment")
    end

    it 'response first transaction should contain sum' do
      expect(@body['sum']).to eq(1000)
    end
  end

  describe 'Create balance increase to 1000' do
    let(:create_t) {
      transaction_params = {
        user_id: user.id,
        transaction_type: 'replenishment',
        sum: 1000
      }

      post api_v1_transactions_path, { params: transaction_params, headers: {'HTTP_ACCEPT' => "application/json"} }
    }

    it 'Balance should increase to 1000' do
      expect{create_t}.to change{Balance.find_by(user_id: user.id).sum}.by(1000)
    end
  end

  describe 'Create balance decrease to 100' do
    let!(:update_balance) { user.balance.update!(sum: 300) }
    let(:create_t) {
      transaction_params = {
        user_id: user.id,
        transaction_type: 'withdrawal',
        sum: 100
      }

      post api_v1_transactions_path, { params: transaction_params, headers: {'HTTP_ACCEPT' => "application/json"} }
    }

    it 'Balance should decrease to 100' do
      expect{create_t}.to change{Balance.find_by(user_id: user.id).sum}.from(300).to(200)
    end
  end

  describe 'Create without user_id' do
    before(:each) {
      transaction_params = {
        transaction_type: 'replenishment',
        sum: 1000
      }

      post api_v1_transactions_path, { params: transaction_params, headers: {'HTTP_ACCEPT' => "application/json"} }
      @body = JSON.parse response.body
    }

    it 'response should not be success' do
      expect(response).to_not be_successful
    end

    it 'status should be 422' do
      expect(response.status).to be(422)
    end

    it 'response should contain error message' do
      expect(@body['error']['messages']).to eq(["User must exist"])
    end
  end

  describe 'Create without sum' do
    before(:each) {
      transaction_params = {
        user_id: user.id,
        transaction_type: 'replenishment'
      }

      post api_v1_transactions_path, { params: transaction_params, headers: {'HTTP_ACCEPT' => "application/json"} }
      @body = JSON.parse response.body
    }

    it 'response should not be success' do
      expect(response).to_not be_successful
    end

    it 'status should be 422' do
      expect(response.status).to be(422)
    end

    it 'response should contain error message' do
      expect(@body['error']['messages']).to eq(["Sum is not a number"])
    end
  end

  describe 'Create with wrong transaction_type' do
    before(:each) {
      transaction_params = {
        user_id: user.id,
        transaction_type: 'wrong',
        sum: 1000
      }

      post api_v1_transactions_path, { params: transaction_params, headers: {'HTTP_ACCEPT' => "application/json"} }
      @body = JSON.parse response.body
    }

    it 'response should not be success' do
      expect(response).to_not be_successful
    end

    it 'status should be 400' do
      expect(response.status).to be(400)
    end

    it 'response should contain error message' do
      expect(@body['error']['messages']).to eq(["'wrong' is not a valid transaction_type"])
    end
  end

  describe 'Create with not exited user_id' do
    before(:each) {
      transaction_params = {
        user_id: 2000,
        transaction_type: 'replenishment',
        sum: 1000
      }

      post api_v1_transactions_path, { params: transaction_params, headers: {'HTTP_ACCEPT' => "application/json"} }
      @body = JSON.parse response.body
    }

    it 'response should not be success' do
      expect(response).to_not be_successful
    end

    it 'status should be 422' do
      expect(response.status).to be(422)
    end

    it 'response should contain error message' do
      expect(@body['error']['messages']).to eq(["User must exist"])
    end
  end
end