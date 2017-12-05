module DomainsScanner
  module Crawlers
    class Google < Base
      def first_search(domain_name, top_level_domain)
        query = search_keyword(domain_name, top_level_domain)
        doc = agent.get("https://google.com/search?q=#{query}&start=#{start}")

        results = parse_results(doc)
        have_next_page = have_next_page?(doc)

        DomainsScanner::Results.new(results, have_next_page)
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

      def have_next_page?(doc)
        doc.search("div#foot .cur+td").any?
      end
    end
  end
end
