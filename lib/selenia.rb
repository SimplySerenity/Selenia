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

        attempts = 1
        source = bridge.page_source
        sleep(options[:delay])

        while source != bridge.page_source and attempts < options[:attempts] do
          source = bridge.page_source
          sleep(options[:delay])
          attempts += 1
        end
      end
    end
  end
end

module Selenia

  # cleans the given link to make the server's life easier
  def self.clean_link(link)
    link
      .partition('#')[0]
      .chomp('/')
  end

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
        raise 'You have to join a pool before you can push links'
      end

      self.class.post('/api/pools/' + @pool_name + '/links', body: { links: links }.to_json)
    end

    def fetch_link()
      if @pool_name == ''
        raise 'You have to join a pool before you can fetch links'
      end

      reponse = self.class.get('/api/pools/' + @pool_name + '/links')
      JSON.parse(reponse.body)
    end
  end
end
