module Piebits
  
  class Report
    attr_reader :category
    attr_reader :tool_name
    attr_reader :tool_version
    attr_reader :data
    
    # data is expected to be a string
    def initialize(category:, tool_name:, tool_version:, data:)
      @category = category
      @tool_name = tool_name
      @tool_version = tool_version
      @data = data
    end
    
    def to_hash
      {
        :category => category,
        :tool_name => tool_name,
        :tool_version => tool_version,
        :data => data
      }
    end
  end
  
end