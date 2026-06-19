# name: discourse-orcid-publications
# about: ORCID (custom_field_id: 3) üzerinden kullanıcı yayınlarını profilde listeler.
# version: 1.0.0
# authors: Discourse Architect
# url: https://github.com/your-org/discourse-orcid-publications

enabled_site_setting :orcid_publications_enabled

register_asset 'stylesheets/orcid-publications.scss'

after_initialize do
  module ::DiscourseOrcidPublications
    PLUGIN_NAME = "discourse-orcid-publications"
  end

  require_relative "app/controllers/orcid_publications_controller.rb"

  Discourse::Application.routes.append do
    get "u/:username/orcid-publications" => "orcid_publications#index", constraints: { username: RouteFormat.username }
  end
end