class AnalyzeSentiment < Haven
  base_uri 'https://api.havenondemand.com/1/api/sync/analyzesentiment/v1'

  def initialize(text)
    @options = { text: text }
  end

  def analyze
    self.class.get("/apikey=#{ENV["haven_token"]}", @options)
  end
end
