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

        Thread.new do
          loop do
            puts "Scanning #{domain} with #{engine} on page: #{page}" if DomainsScanner.verbose

            begin
              results = crawler.search(@domain_word, @top_level_domain, page)
              results.items.each do |item|
              DomainsScanner.output_queue.push({
                  domain: item.host, top_level_domain: @top_level_domain, engine: engine
                })
              end
              break unless results.have_next_page
            rescue Mechanize::ResponseCodeError => e
            end

            break unless page < DomainsScanner.max_page
            page += 1
          end
        end
      end

      @workers.each(&:join)
    end
  end
end