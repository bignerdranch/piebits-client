require 'spec_helper'
require 'faraday'

describe Piebits::App do
  let(:error_string_io) { StringIO.new }
  let(:output_string_io) { StringIO.new }

  it "can be initialized" do
    app = described_class.new(environment: ENV, arguments: ARGV)
    expect(app.environment).to eq(ENV)
    expect(app.working_dir).to eq(ENV['PWD'])
    expect(app.arguments).to eq(ARGV)
  end

  it "can run and submit a build successfully" do
    fixture_dir = File.join(__dir__, "../fixtures")
    env = {
      'PWD' => fixture_dir,
      'TRAVIS_COMMIT' => 'abc123',
      'PIEBITS_API_TOKEN' => '123abc'
    }
    expected_json = "{\"timestamp\":null,\"commit_sha\":\"abc123\",\"ci_build_url\":null,\"reports\":[{\"category\":\"analysis\",\"tool_name\":\"oclint\",\"tool_version\":null,\"data\":\"fake oclint json\"}]}"
    expected_headers = { 
      'Content-Type' => 'application/json',
      'Authorization' => "Token token=\"#{env['PIEBITS_API_TOKEN']}\""
    }

    # stub out our expected request with a success response
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.post('/api/builds', expected_json, expected_headers) { |env| [ 200, {}, '' ] }
    end
    # create a test faraday using our stubs
    test_faraday = Faraday.new do |builder|
      builder.adapter :test, stubs
    end

    app = described_class.new(environment: env, arguments: [], faraday: test_faraday,
      config_filename: 'config-with-oclint.yml', output_io: output_string_io, error_io: error_string_io)
    exit_code = app.run

    expect(exit_code).to eq(0)
    expect(output_string_io.string).to eq("Build submitted successfully.\n")
    expect(error_string_io.string).to eq("")
    # ensure that we got called
    stubs.verify_stubbed_calls
  end

  it "fails if there is no Piebits API Token in the environment" do
    app = described_class.new(environment: {}, arguments: [], error_io: error_string_io)
    exit_code = app.run

    expect(exit_code).to eq(1)
    expect(error_string_io.string).to eq("Please specify your API token in PIEBITS_API_TOKEN\n")
  end

  it "reports an error if the build submission returns an error" do
    pending
    fail
  end
end
