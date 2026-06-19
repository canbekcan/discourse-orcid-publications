class OrcidPublicationsController < ::ApplicationController
  requires_plugin ::DiscourseOrcidPublications::PLUGIN_NAME

  def index
    user = User.find_by_username(params[:username])
    raise Discourse::NotFound unless user
    
    # Güvenlik: Kullanıcı profilini görme yetkisi kontrolü
    guardian.ensure_can_see_profile!(user)

    # custom_field_id: 3 veritabanında 'user_field_3' olarak tutulur.
    raw_orcid = user.custom_fields["user_field_3"]
    orcid_id = nil

    if raw_orcid.present?
      # Gelen değer tam bir URL ise (https://orcid.org/...) parçalayıp sadece en sondaki ID'yi al.
      # Sadece ID geldiyse değişiklik yapmadan kullan.
      orcid_id = raw_orcid.strip.split('/').last
    end

    if orcid_id.blank?
      return render json: { publications: [], error: "ORCID ID bulunamadı veya gizli." }, status: :ok
    end

    cache_key = "orcid_publications_#{orcid_id}"
    
    # Redis Caching (12 Saat) - Dış API bağımlılığını ve N+1 sorunlarını önler.
    publications = Discourse.cache.fetch(cache_key, expires_in: 12.hours) do
      fetch_from_orcid(orcid_id)
    end

    render json: { publications: publications }
  end

  private

  def fetch_from_orcid(orcid_id)
    url = "https://pub.orcid.org/v3.0/#{orcid_id}/works"
    
    # Excon, Discourse'un standart HTTP istemcisidir.
    response = Excon.get(url, headers: { 'Accept' => 'application/json' }, connect_timeout: 5, read_timeout: 5)
    
    return [] unless response.status == 200
    
    parse_orcid_response(JSON.parse(response.body))
  rescue => e
    Discourse.warn_exception(e, message: "ORCID API hatası: #{orcid_id}")
    []
  end

  def parse_orcid_response(data)
    return [] if data["group"].blank?

    data["group"].map do |group|
      summary = group["work-summary"]&.first
      next unless summary

      # OIDC standartlarına uygun veri ayıklama
      title = summary.dig("title", "title", "value")
      year = summary.dig("publication-date", "year", "value")
      journal = summary.dig("journal-title", "value")
      
      url = summary.dig("url", "value")
      if url.nil? && summary["external-ids"] && summary["external-ids"]["external-id"]
        doi_node = summary["external-ids"]["external-id"].find { |eid| eid["external-id-type"] == "doi" }
        url = doi_node.dig("external-id-url", "value") if doi_node
      end

      { title: title, year: year, journal: journal, url: url }
    end.compact
  end
end