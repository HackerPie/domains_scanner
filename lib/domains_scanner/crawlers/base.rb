require 'domains_scanner/results'

module DomainsScanner
  module Crawlers
    TOP_LEVEL_DOMAINS = %w(com cn com.cn net org ltd cc mobi live io co me hk).freeze

    class Base
      def initialize(domain_name, top_level_domains = TOP_LEVEL_DOMAINS)
        @domain_name = domain_name
        @top_level_domains = Array(top_level_domains)
      end

      def agent
        @agent ||= Mechanize.new do |agent|
          agent.user_agent_alias = "Mac Safari"
        end
      end

      def search_keyword(domain_name, top_level_domain)
        "site:*.#{domain_name}.#{top_level_domain}"
      end

      def search(domain_name, top_level_domain, page = 1)
        raise NotImplementedError, "#{self.class.name}#search need to be implmented in sub class"
      end
    end
  end
end