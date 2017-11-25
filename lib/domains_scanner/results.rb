require 'domains_scanner/result_item'

module DomainsScanner
  class Results
    attr_reader :items, :have_next_page

    def initialize(results, have_next_page)
      @items = results.map do |result|
        ResultItem.new(title: result[:title], url: result[:url])
      end
      @have_next_page = have_next_page
    end
  end
end