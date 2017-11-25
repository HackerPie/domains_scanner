require 'mechanize'
require 'domains_scanner/crawlers/base'
require 'domains_scanner/crawlers/baidu'
require 'domains_scanner/crawlers/google'

module DomainsScanner
  module Crawlers
    def self.build(engine)
      case engine.to_s
      when "google"
        Google.new
      when "baidu"
        Baidu.new
      end
    end
  end
end