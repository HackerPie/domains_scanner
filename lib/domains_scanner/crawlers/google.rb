module DomainsScanner
  module Crawlers
    class Google < Base
      def host
        "https://google.com"
      end

      def keyword_field_name
        "q"
      end

      # [{title: "xxx", url: "xxx"}, ...]
      def parse_results(doc)
        items = doc.search(".g h3.r a")
        items.map do |i|
          title = i.text
          href = i.attributes["href"] && i.attributes["href"].value
          # https://bbs.abc.net/thread-144889-1-1.html&sa=U&ved=0ahUKEwjpmNT0ltnXAhXMxLwKHQJIAmE4ChAWCBQwAA&usg=AOvVaw31kkGPP7ZVlFGlAby9OkzE
          url = if href
            href.sub("/url?q=", "")
          end

          { title: i.text, url: url }
        end
      end

      def next_page_link_selector
        "div#foot .cur+td>a"
      end
    end
  end
end
