module DomainsScanner
  module Crawlers
    class Baidu < Base
      def host
        "https://www.baidu.com"
      end

      def search_by_form(domain_name, top_level_domain)
        doc = agent.get(host)

        form = doc.forms.first
        query = search_keyword(domain_name, top_level_domain)
        form['wd'] = query
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

      # [{title: "xxx", url: "xxx"}, ...]
      def parse_results(doc)
        items = doc.search(".result")
        items.map do |i|
          title = i.search("h3.t > a").text
          # Baidu encrypted the target url, so we can use show url only, but it is enough!
          # bbs.abc.net/for...php?...
          show_url = i.search("div:last-child > a.c-showurl")
          url = if show_url
            if show_url.text.start_with?("http")
              show_url.text
            else
              "http://#{show_url.text}"
            end
          end

          { title: i.text, url: URI.encode(url) }
        end
      end

      def parse_next_page_link(doc)
        next_page_tag = doc.search("#page strong+a").first
        return unless next_page_tag

        href = next_page_tag.attributes["href"]
        "#{host}#{href}"
      end
    end
  end
end
