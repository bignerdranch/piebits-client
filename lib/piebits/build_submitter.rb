require 'json'

module Piebits

  class BuildSubmitter
    attr_reader :build

    BUILDS_ENDPOINT = '/api/builds'

    def initialize(api_token:, build:, faraday:)
      @api_token = api_token
      @build = build
      @faraday = faraday
    end

    def submit_build
      @faraday.post do |req|
        req.url BUILDS_ENDPOINT
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = "Token token=\"#{@api_token}\""
        req.body = JSON.generate(build.to_hash)
      end
    end
  end

end
