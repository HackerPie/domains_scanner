module DomainsScanner
  class Printer
    class << self
      def puts(message = nil)
        if DomainsScanner.verbose
          message = yield if block_given?
          Kernel.puts message if message
        end
      end
    end
  end
end