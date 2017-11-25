require 'uri'
require 'thread'
require "domains_scanner/version"
require "domains_scanner/crawlers"
require "domains_scanner/runner"

module DomainsScanner
  PRINT_LINE_LENGTH = 80
  TOP_LEVEL_DOMAINS = %w(com cn com.cn net org ltd cc mobi live io co me hk).freeze

  class << self
    attr_accessor :verbose, :max_page, :engines
    DomainsScanner.verbose = true
    DomainsScanner.max_page = 20
    DomainsScanner.engines = %w(baidu google)

    def output_queue
      @output_queue ||= Queue.new
    end

    def scan(domain_word:, top_level_domains: TOP_LEVEL_DOMAINS)
      runners = top_level_domains.map do |top_level_domain|
        Runner.new(domain_word: domain_word, top_level_domain: top_level_domain)
      end
      runners.each(&:run)

      puts "Start analysis crawl results..." if DomainsScanner.verbose
      list = analysis_output_queue

      print_list(list)
    end

    def analysis_output_queue
      list = {}
      begin
        while(result = output_queue.pop(non_block = true)) do
          domain, top_level_domain, engine = result.values_at(:domain, :top_level_domain, :engine)
          group = list[top_level_domain] ||= {}
          group[domain] ||= []

          group[domain] << engine unless group[domain].include?(engine)
        end
      rescue ThreadError # queue is empty
      end

      list
    end

    def print_list(list)
      list.each do |group_name, group|
        puts "Found domains for .#{group_name}\n#{"-" * 50}"
        group.each do |domain, engines|
          tips_para = "Search Engine: #{engines.join(", ")}"
          points_count = [PRINT_LINE_LENGTH - domain.length - tips_para.length - 2, 0].max
          puts "#{domain} #{'·' * points_count} #{tips_para}"
        end
        puts ""
      end;nil
    end
  end
end
