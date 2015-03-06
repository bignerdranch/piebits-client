module Piebits
  
  class BuildGenerator
    attr_reader :environment
    attr_reader :working_dir
    attr_reader :configuration
    
    def initialize(environment, working_dir, config_filename)
      @environment = environment
      @working_dir = working_dir
      config_hash = YAML.safe_load(IO.read(config_filename))
      @configuration = Configuration.new(config_hash)
    end
    
    def generate_build
      sha = environment["TRAVIS_COMMIT"]
      build = Build.new(timestamp: nil, commit_sha: sha, ci_build_url: nil)
      configuration.reports.each do |config_report|
        report_data = IO.read(File.join(working_dir, config_report.report_filename))
        report = Report.new(category: config_report.category, tool_name: config_report.tool_name, tool_version: nil, data: report_data)
        build.add_report(report)
      end
      return build
    end
    
  end
  
end