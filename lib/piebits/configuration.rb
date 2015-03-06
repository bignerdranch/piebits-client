module Piebits
  class Configuration
    attr_reader :reports
    
    def initialize(config_hash)
      @reports = config_hash["reports"].map do |report_hash|
        Configuration::Report.new(report_hash["tool_name"], report_hash["category"], report_hash["report_filename"])
      end
    end
    
    def eql?(other)
      self.class.equal?(other.class) &&
        self.reports == other.reports
    end
    
    Report = Struct.new(:tool_name, :category, :report_filename)
    
  end
end