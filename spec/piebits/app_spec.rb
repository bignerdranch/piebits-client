require 'spec_helper'

describe Piebits::App do
  
  it "can be initialized" do
    app = described_class.new(environment: ENV, arguments: ARGV)
    expect(app.environment).to eq(ENV)
    expect(app.working_dir).to eq(ENV['PWD'])
    expect(app.arguments).to eq(ARGV)
  end
  
  it "can be run" do
    fixture_dir = File.join(__dir__, "../fixtures")
    output_string_io = StringIO.new
    error_string_io = StringIO.new
    env = {
      'PWD' => fixture_dir,
      'TRAVIS_COMMIT' => 'abc123'
    }
    app = described_class.new(environment: env, arguments: [],
      config_filename: 'config-with-oclint.yml', output_io: output_string_io, error_io: error_string_io)
    app.run
    
    expected_output = "{\"timestamp\":null,\"commit_sha\":\"abc123\",\"ci_build_url\":null,\"reports\":[{\"category\":\"analysis\",\"tool_name\":\"oclint\",\"tool_version\":null,\"data\":\"fake oclint json\"}]}\n"
    
    expect(output_string_io.string).to eq(expected_output)
    expect(error_string_io.string).to eq("")
  end
end