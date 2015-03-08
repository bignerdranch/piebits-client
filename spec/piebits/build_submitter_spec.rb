require 'spec_helper'
require 'faraday'
require 'json'

RSpec.describe Piebits::BuildSubmitter do
  let(:build) {
    Piebits::Build.new(timestamp: 13245, commit_sha: 'abc123', ci_build_url: 'http://foo.bar').tap do |b|
      b.add_report(report)
    end
  }
  let(:report) { Piebits::Report.new(category: 'ducks', tool_name: 'ducker',
                                     tool_version: '1.0', data: 'quack quack quack')
  }

  it "can be initialized with a build" do
    submitter = described_class.new(api_token: nil, build: build, faraday: nil)
    expect(submitter.build).to eq(build)
  end

  it "can submit a build successfully" do
    token = "abc123"
    expected_json_body = JSON.generate(build.to_hash)
    expected_headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Token token=\"#{token}\""
    }
    # stub out our expected request with a success response
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.post('/api/builds', expected_json_body, expected_headers) { |env| [ 200, {}, '' ] }
    end
    # create a test faraday using our stubs
    test_faraday = Faraday.new do |builder|
      builder.adapter :test, stubs
    end

    submitter = described_class.new(api_token: token, build: build, faraday: test_faraday)
    response = submitter.submit_build
    expect(response).to_not be_nil
    expect(response.success?).to be(true)
    expect(response.status).to be(200)

    stubs.verify_stubbed_calls
  end
end
