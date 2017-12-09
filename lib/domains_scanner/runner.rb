module DomainsScanner
  class Runner
    attr_reader :workers

    def initialize(domain_word:, top_level_domain:)
      @domain_word = domain_word
      @top_level_domain = top_level_domain
    end

    def run
      domain = "#{@domain_word}.#{@top_level_domain}"
      DomainsScanner::Printer.puts { "Start scan #{domain}".green }
      @workers = DomainsScanner.engines.map do |engine|
        crawler = DomainsScanner::Crawlers.build(engine)
        page = 1
        next_page_link = nil

        Thread.new do
          loop do
            DomainsScanner::Printer.puts { "Scanning #{domain} with #{engine} on page: #{page}".yellow }

            begin
              if page == 1
                DomainsScanner::Printer.puts { "Search by form>>" }
                results = crawler.search_by_form(@domain_word, @top_level_domain)
              else
                DomainsScanner::Printer.puts { "Search by link: #{next_page_link}>>" }
                results = crawler.search_by_link(next_page_link)
              end
              next_page_link = results.next_page_link

              results.items.each do |item|
                # Avoid some unexpected hostname from ads
                if item.host.to_s.include?(domain)
                  DomainsScanner.output_queue.push({
                      domain: item.host, top_level_domain: @top_level_domain, engine: engine
                    })
                else
                  DomainsScanner::Printer.puts { "Abondon unexpected domain: #{item.host}".red }
                end
              end
            rescue Mechanize::ResponseCodeError => e
              DomainsScanner::Printer.puts { "Search in #{engine} error, skip now! Reason: #{e.message}".red  }
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