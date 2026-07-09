# name: discourse-orcid-publications
# about: ORCID (custom_field_id: 3) üzerinden kullanıcı yayınlarını profilde listeler.
# version: 1.0.0
# authors: Can Bekcan
# url: https://github.com/canbekcan/discourse-orcid-publications

enabled_site_setting :orcid_publications_enabled

register_asset 'stylesheets/orcid-publications.scss'

after_initialize do
  module ::DiscourseOrcidPublications
    PLUGIN_NAME = "discourse-orcid-publications"
  end

  require_relative "app/controllers/orcid_publications_controller.rb"

  add_to_serializer(:user, :has_orcid) do
    UserAssociatedAccount.exists?(user_id: object.id, provider_name: ['orcid_connect', 'orcid'])
  end

  Discourse::Application.routes.append do
    # 1. Frontend'in JSON verisi çektiği Backend API Rotası
    get "u/:username/orcid-publications" => "orcid_publications#index", constraints: { username: RouteFormat.username }
    
    # 2. Sayfa yenilendiğinde Rails'in Ember.js arayüzünü başlatmasını sağlayan UI Rotası
    get "u/:username/publications" => "users#show", constraints: { username: RouteFormat.username }
  end
end