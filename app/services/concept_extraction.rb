class ConceptExtraction < Haven
  base_uri 'https://api.havenondemand.com/1/api/sync/analyzesentiment/v1'

  def initialize(link)
    @url = link
  end

  def analyze
    self.class.get("?url=#{@url}&apikey=#{ENV["haven_token"]}")
  end
end
