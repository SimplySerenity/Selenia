require 'selenia/version'
require 'httparty'
require 'json'

module Selenium
  module WebDriver
    class Driver
      # navigates to the specified url
      # waits for either the page source to stop changing or enough time to pass
      def get_fully_loaded(url, options = {})
        options = { delay: 30, attempts: 5 }.merge(options)

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

module Selenia
  class Server
    include HTTParty

    def initialize(address)
      self.class.base_uri address
      self.class.headers 'Content-Type' => 'application/json'
      @pool_name = ''
    end

    def join_or_init_pool(pool_name, links)
      @pool_name = pool_name
      self.class.post('/api/pools/' + @pool_name, body: { links: links }.to_json)
    end

    def push_links(links)
      if @pool_name == ''
        # something bad
      end

      reponse = self.class.post('/api/pools/' + @pool_name + '/links', body: { links: links }.to_json)
      JSON.parse(reponse.body)
    end

    def fetch_link()
      reponse = self.class.get('/api/pools/' + @pool_name + '/links')
      JSON.parse(reponse.body)
    end
  end
end
