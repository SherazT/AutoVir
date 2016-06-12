class AnalyzeSentiment < Haven
  base_uri 'https://api.havenondemand.com/1/api/sync/analyzesentiment/v1'

  def initialize(text)
    @options = { apikey: ENV["haven_token"], text: text }
  end

  def analyze
    self.class.get("", @options)
  end
end
