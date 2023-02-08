require 'rails_helper'

RSpec.describe 'Messages API', type: :request do
  let(:agus) { create(:user) }
  let(:dimas) { create(:user) }
  let(:dimas_headers) { valid_headers(dimas.id) }

  let(:samid) { create(:user) }
  let(:samid_headers) { valid_headers(samid.id) }

  # TODO: create conversation between Dimas and Agus, then set convo_id variable

  describe 'get list of messages' do
    context 'when user have conversation with other user' do
      before { get "/conversations/#{convo_id}/messages", params: {}, headers: dimas_headers }

      it 'returns list all messages in conversation' do
        expect_response(
          :ok,
          data: [
            {
              id: Integer,
              message: String,
              sender: {
                id: Integer,
                name: String
              },
              sent_at: String
            }
          ]
        )
      end
    end

    context 'when user try to access conversation not belong to him' do
      # TODO: create conversation and set convo_id variable
      let(:room) {create(:conversation)}
      let(:convo_id) {room.id}
      
      before { get "/conversations/#{convo_id}/messages", params: {}, headers: samid_headers }

      it 'returns error 403' do
        expect(response).to have_http_status(403)
      end
    end

    context 'when user try to access invalid conversation' do
      # TODO: create conversation and set convo_id variable
      before { get "/conversations/-11/messages", params: {}, headers: samid_headers }

      it 'returns error 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'send message' do
    let(:valid_attributes) do
      { message: 'Hi there!', user_id: agus.id }.to_json
    end

    let(:invalid_attributes) do
      { message: '', user_id: agus.id }.to_json
    end

    context 'when request attributes are valid' do
      before { post "/messages", params: valid_attributes, headers: dimas_headers}

      it 'returns status code 201 (created) and create conversation automatically' do
        expect_response(
          :created,
          data: {
            id: Integer,
            message: String,
            sender: {
              id: Integer,
              name: String
            },
            sent_at: String,
            conversation: {
              id: Integer,
              with_user: {
                id: Integer,
                name: String,
                photo_url: String
              }
            }
          }
        )
      end
    end

    context 'when create message into existing conversation' do
      before { post "/messages", params: valid_attributes, headers: dimas_headers}

      it 'returns status code 201 (created) and create conversation automatically' do
        expect_response(
          :created,
          data: {
            id: Integer,
            message: String,
            sender: {
              id: Integer,
              name: String
            },
            sent_at: String,
            conversation: {
              id: Integer,
              with_user: {
                id: Integer,
                name: String,
                photo_url: String
              }
            }
          }
        )
      end
    end

    context 'when an invalid request' do
      before { post "/messages", params: invalid_attributes, headers: dimas_headers}

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end
  end
end
