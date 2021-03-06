require 'rails_helper'

describe Api::V1::BookSuggestionsController do
  describe 'POST #create' do
    let(:bs_attrs) { attributes_for(:book_suggestion) }

    context 'when logged in user creates a book suggestion' do
      include_context 'Authenticated User'

      before { post :create, params: { book_suggestion: bs_attrs } }

      it { expect(response).to have_http_status(:created) }

      it 'returns a book_suggestion with the bs_attrs' do
        expect(response_body['title']).to eq bs_attrs[:title]
      end

      it 'returns the user' do
        expect(response_body['user']['id']).to eq user.id
      end
    end

    context 'when visitor creates a book suggestion' do
      before { post :create, params: { book_suggestion: bs_attrs } }

      it { expect(response).to have_http_status(:created) }

      it 'returns a book_suggestion with the bs_attrs' do
        expect(response_body['title']).to eq bs_attrs[:title]
      end

      it 'it does not return a user' do
        expect(response_body['user']).to be_nil
      end
    end

    context 'when required attributes are missing' do
      before { post :create, params: { book_suggestion: bs_attrs.merge(author: nil) } }

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it 'returns a book_suggestion with the bs_attrs' do
        expect(response_body['errors']['author']).to include 'can\'t be blank'
      end
    end
  end
end
