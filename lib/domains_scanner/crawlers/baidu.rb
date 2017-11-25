module DomainsScanner
  module Crawlers
    class Baidu < Base
      def search(domain_name, top_level_domain, page = 1)
        query = search_keyword(domain_name, top_level_domain)
        start = (page - 1) * 10
        doc = agent.get("https://www.baidu.com/s?wd=#{query}&pn=#{start}")

        results = parse_results(doc)
        have_next_page = have_next_page?(doc)

        DomainsScanner::Results.new(results, have_next_page)
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

      def have_next_page?(doc)
        doc.search("#page strong+a").any?
      end
    end
  end
end
