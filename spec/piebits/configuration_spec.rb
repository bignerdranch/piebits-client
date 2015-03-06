require 'spec_helper'
require 'yaml'

describe Piebits::Configuration do
  
  it "loads a basic config" do
    yaml_content = IO.read(File.join(__dir__, "../fixtures/config-with-oclint.yml"))
    expect(yaml_content).to be_truthy
    config_hash = YAML.safe_load(yaml_content)
    expect(config_hash).to_not be_nil
    
    # init our Configuration
    config = described_class.new(config_hash)
    
    # verify that we got one report config for oclint
    reports = config_hash["reports"]
    expect(reports.size).to eq(1)
    oclint_report_hash = reports[0]
    oclint_report_config = config.reports[0]
    expect(oclint_report_config.tool_name).to eq(oclint_report_hash["tool_name"])
    expect(oclint_report_config.category).to eq(oclint_report_hash["category"])
    expect(oclint_report_config.report_filename).to eq(oclint_report_hash["report_filename"])
    
  end
end