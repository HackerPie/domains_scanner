require 'domains_scanner/result_item'

module DomainsScanner
  class Results
    attr_reader :items, :next_page_link

    def initialize(results, next_page_link)
      @items = results.map do |result|
        ResultItem.new(title: result[:title], url: result[:url])
      end
      @next_page_link = next_page_link
    end
  end
end