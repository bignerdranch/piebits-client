require 'spec_helper'
require 'faraday'
require 'json'

describe Piebits::BuildSubmitter do
  
  let(:build) {
    build = Piebits::Build.new(timestamp: 13245, commit_sha: 'abc123', ci_build_url: 'http://foo.bar')
    report = Piebits::Report.new(category: 'ducks', tool_name: 'ducker', tool_version: '1.0', data: 'quack quack quack')
    build.add_report(report)
    build
  }
  
  it "can be initialized with a build" do
    submitter = described_class.new(build: build, faraday: nil)
    expect(submitter.build).to eq(build)
  end
  
  it "can submit a build successfully" do
    expected_json_body = JSON.generate(build.to_hash)
    
    # stub out our expected request with a success response
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.post('/api/builds', expected_json_body, { 'Content-Type' => 'application/json' }) { |env| [ 200, {}, '' ] }
    end
    # create a test faraday using our stubs
    test_faraday = Faraday.new do |builder|
      builder.adapter :test, stubs
    end
    
    submitter = described_class.new(build: build, faraday: test_faraday)
    response = submitter.submit_build
    expect(response).to_not be_nil
    expect(response.success?).to be(true)
    expect(response.status).to be(200)
    # ensure that we got called
    stubs.verify_stubbed_calls
  end
end