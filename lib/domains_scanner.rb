require 'uri'
require 'thread'
require 'ansi_colors'
require "domains_scanner/version"
require "domains_scanner/printer"
require "domains_scanner/crawlers"
require "domains_scanner/runner"

module DomainsScanner
  TOP_LEVEL_DOMAINS = %w(com cn com.cn net org ltd cc mobi live io co me hk).freeze

  class << self
    attr_accessor :verbose, :max_page, :engines
    DomainsScanner.verbose = false
    DomainsScanner.max_page = 20
    DomainsScanner.engines = %w(baidu google)

    def output_queue
      @output_queue ||= Queue.new
    end

    def scan(domain_word:, top_level_domains: TOP_LEVEL_DOMAINS)
      top_level_domains ||= TOP_LEVEL_DOMAINS

      runners = top_level_domains.map do |top_level_domain|
        Runner.new(domain_word: domain_word, top_level_domain: top_level_domain)
      end
      runners.each(&:run)

      DomainsScanner::Printer.puts { "Start analysis crawl results...".green }
      analysis_output_queue
    end

    def analysis_output_queue
      list = {}
      begin
        while(result = output_queue.pop(non_block = true)) do
          domain, top_level_domain, engine = result.values_at(:domain, :top_level_domain, :engine)
          next unless domain

          group = list[top_level_domain] ||= {}
          group[domain] ||= []

          group[domain] << engine unless group[domain].include?(engine)
        end
      rescue ThreadError # queue is empty
      end

      list
    end
  end
end
