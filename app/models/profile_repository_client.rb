class ProfileRepositoryClient
  def self.base_url
    ENV['PROFILE_DATA_REPO_URL'] || 'http://profile:4581'
  end

  def self.get(path)
    url = "#{base_url}/#{path}"
    RestClient.get(url, {content_type: :json, accept: :json}) do |resp, req, result|
      {status: resp.code, body: resp.body}
    end
  end
end