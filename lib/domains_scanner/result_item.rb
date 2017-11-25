require 'uri'

module DomainsScanner
  class ResultItem
    attr_reader :title, :url, :uri

    def initialize(title:, url:)
      @title = title
      @url = url

      if url
        @uri = URI(@url)
      end
    end

    def host
      @uri && @uri.host
    end
  end
end