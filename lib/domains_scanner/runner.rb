module DomainsScanner
  class Runner
    attr_reader :workers

    def initialize(domain_word:, top_level_domain:)
      @domain_word = domain_word
      @top_level_domain = top_level_domain
    end

    def run
      domain = "#{@domain_word}.#{@top_level_domain}"
      puts "Start scan #{domain}" if DomainsScanner.verbose
      @workers = DomainsScanner.engines.map do |engine|
        crawler = DomainsScanner::Crawlers.build(engine)
        page = 1
        next_page_link = nil

        Thread.new do
          loop do
            puts "Scanning #{domain} with #{engine} on page: #{page}" if DomainsScanner.verbose

            begin
              if page == 1
                puts "Search by form>>>>" if DomainsScanner.verbose
                results = crawler.search_by_form(@domain_word, @top_level_domain)
              else
                puts "Search by link: #{next_page_link}>>>>" if DomainsScanner.verbose
                results = crawler.search_by_link(next_page_link)
              end
              next_page_link = results.next_page_link

              results.items.each do |item|
                DomainsScanner.output_queue.push({
                    domain: item.host, top_level_domain: @top_level_domain, engine: engine
                  })
              end
            rescue Mechanize::ResponseCodeError => e
              puts "search in #{engine} error, skip now" if DomainsScanner.verbose
            end

            break unless next_page_link && page < DomainsScanner.max_page
            page += 1
          end
        end
      end

      @workers.each(&:join)
    end
  end
end