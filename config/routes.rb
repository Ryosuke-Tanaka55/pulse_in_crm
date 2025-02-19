# frozen_string_literal: true

Rails.application.routes.draw do # rubocop:disable Metrics/BlockLength
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  # admin関連=========================================================
  devise_for :admins, controllers: {
    sessions: 'admins/sessions'
  }
  # =================================================================

  # user関連==========================================================
  devise_scope :user do
    get ':company_id/sign_in' => 'users/sessions#new', as: :user_login
    post ':company_id/sign_in' => 'users/sessions#create', as: :user_session
    delete '/users/sign_out' => 'users/sessions#destroy', as: :destroy_user_session
    get '/cancel' => 'users/registrations#cancel', as: :cancel_user_registration
    get '/sign_up' => 'users/registrations#new', as: :new_user_registration
    post '/sign_up' => 'users/registrations#create', as: :create_user_registration
    get '/edit' => 'users/registrations#edit', as: :edit_user_registration
    put '/users' => 'users/registrations#update', as: :user_registration
  end

  devise_for :users, skip: %i[registrations sessions], controllers: {
    passwords:     'users/passwords',
    confirmations: 'users/confirmations'
  }

  namespace :users do
    resources :dash_boards, only: %i[index]
    resource :profile, except: %i[create new]
    resources :privacy_policy, only: %i[create update edit]
    resources :users
    resources :inquiry_replies, only: %i[new create show]
    resource :company, only: %i[show edit update]
    # ↓メール通知動作確認のため設定。運用時は要修正。↓
    resource :inquiries, only: %i[create]
    resources :thanks, except: %i[index show destroy]
    # =================================================================
    resources :thanks, except: %i[index show destroy]
    resource :company, only: %i[show edit update]
    resource :inquiries, only: %i[create]
  end
  # =================================================================

  # 共通==============================================================
  # プライバシーポリシー表示
  get '/privacy_policy/:id' => 'privacy_policy#show', as: :privacy_policy
  # サンクスページ表示
  get '/thank/:id' => 'thanks#show', as: :thank
  # マークダウン記法一覧ページ
  get '/markdown' => 'markdown#index'
  # トップページ
  root 'use#top'
  # アカウント登録後ページ
  get 'registration_comp' => 'use#registration_comp'
  # 利用規約
  get 'use' => 'use#index'
  # =================================================================
end
