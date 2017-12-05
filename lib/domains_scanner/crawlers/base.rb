require 'domains_scanner/results'

module DomainsScanner
  module Crawlers
    class Base
      def initialize
      end

      def agent
        @agent ||= Mechanize.new do |agent|
          agent.user_agent_alias = "Mac Safari"
        end
      end

      def search_keyword(domain_name, top_level_domain)
        "site:*.#{domain_name}.#{top_level_domain}"
      end
    end
  end
end