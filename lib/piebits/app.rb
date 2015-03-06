require 'json'

module Piebits
  class App
    attr_reader :environment
    attr_reader :working_dir
    attr_reader :arguments
    
    DEFAULT_CONFIG_FILENAME = ".piebits.yml"
    
    def initialize(environment:, arguments:, config_filename:DEFAULT_CONFIG_FILENAME, 
        input_io:STDIN, output_io:STDOUT, error_io:STDERR)
      @environment = environment
      @working_dir = environment['PWD'] # TODO: allow override with an argument
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
      
      # intialize a BuildGenerator
      build_generator = BuildGenerator.new(environment: environment, 
        working_dir: working_dir, 
        config_filename: File.join(working_dir, @config_filename)
        )
      # generate a build
      build = build_generator.generate_build
      # convert the build to JSON
      json = JSON.generate(build.to_hash)
      # spit it out
      @output_io.puts json
      
      # upload the build to our service
      
    ensure
      $stderr = previous_stderr
    end
  end
end