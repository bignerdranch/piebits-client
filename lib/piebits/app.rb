require 'json'
require 'faraday'

module Piebits
  class App
    attr_reader :environment
    attr_reader :working_dir
    attr_reader :arguments
    
    DEFAULT_CONFIG_FILENAME = ".piebits.yml"
    PIEBITS_URL = "http://piebits.com"
    ENV_PIEBITS_URL = 'PIEBITS_URL'
    ENV_API_TOKEN = 'PIEBITS_API_TOKEN'
    
    def initialize(environment:, arguments:, faraday:nil, config_filename:DEFAULT_CONFIG_FILENAME, 
        input_io:STDIN, output_io:STDOUT, error_io:STDERR)
      @environment = environment
      @working_dir = environment['PWD'] # TODO: allow override with an argument
      url = environment[ENV_PIEBITS_URL] || PIEBITS_URL
      @faraday = faraday || Faraday.new(url)
      @config_filename = config_filename
      @arguments = arguments
      @input_io = input_io
      @output_io = output_io
      @error_io = error_io
    end
    
    def run
      # redirect STDERR
      previous_stderr = $stderr
      $stderr = @error_io
      
      # ensure we have a sane environment
      api_token = environment[ENV_API_TOKEN]
      unless api_token
        @error_io.puts "Please specify your API token in #{ENV_API_TOKEN}"
        return 1
      end
      
      # intialize a BuildGenerator
      build_generator = BuildGenerator.new(environment: environment, 
        working_dir: working_dir, 
        config_filename: File.join(working_dir, @config_filename)
        )
      # generate a build
      build = build_generator.generate_build
      # submit the build to the service
      submitter = BuildSubmitter.new(build: build, faraday: @faraday)
      response = submitter.submit_build
      if response.success?
        @output_io.puts "Build submitted successfully."
        return 0
      else
        @error_io.puts "Failed to submit build. Response: #{response}"
        return 1
      end
    ensure
      $stderr = previous_stderr
    end
  end
end