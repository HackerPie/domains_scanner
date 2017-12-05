module DomainsScanner
  module Crawlers
    class Baidu < Base
      def host
        "https://www.baidu.com"
      end

      def keyword_field_name
        "wd"
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

      def next_page_link_selector
        "#page strong+a"
      end
    end
  end
end
