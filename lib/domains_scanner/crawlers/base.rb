require 'domains_scanner/results'

module DomainsScanner
  module Crawlers
    class Base
      def agent
        @agent ||= Mechanize.new do |agent|
          agent.user_agent_alias = "Mac Safari"
        end
      end

      def search_by_form(domain_name, top_level_domain)
        doc = agent.get(host)

        form = doc.forms.first
        query = search_keyword(domain_name, top_level_domain)
        form[keyword_field_name] = query
        doc = form.submit

        results = parse_results(doc)
        next_page_link = parse_next_page_link(doc)

        DomainsScanner::Results.new(results, next_page_link)
      end

      def search_by_link(link)
        doc = agent.get(link)
        results = parse_results(doc)
        next_page_link = parse_next_page_link(doc)

        DomainsScanner::Results.new(results, next_page_link)
      end

      def parse_next_page_link(doc)
        next_page_tag = doc.search(next_page_link_selector).first
        return unless next_page_tag

        href = next_page_tag.attributes["href"]
        "#{host}#{href}"
      end

      def search_keyword(domain_name, top_level_domain)
        "site:*.#{domain_name}.#{top_level_domain}"
      end

      def keyword_field_name
        raise NotImplementedError
      end

      def parse_results(doc)
        raise NotImplementedError
      end

      def have_next_page?(doc)
        raise NotImplementedError
      end
    end
  end
end