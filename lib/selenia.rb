require 'selenia/version'

module Selenium
  module WebDriver
    class Driver

      # navigates to the specified url
      # waits for either the page source to stop changing or enough time to pass
      def get_fully_loaded(url, options = {})
        options.reverse_merge!(delay: 30, attempts: 5)

        navigate.to(url)

        source = bridge.page_source
        attempts = 0

        begin
          sleep(options[:delay])
          source = bridge.page_source
          attempts += 1
        end unless source != bridge.page_source and attempts < options[:attempts]
      end
    end
  end
end
