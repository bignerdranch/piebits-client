require 'spec_helper'

include Piebits

describe Build do
  let(:timestamp) { 12345 }
  let(:commit_sha) { 'abc123' }
  let(:ci_build_url) { 'http://foo.bar' }
  
  it "converts itself into a hash" do
    build = described_class.new(timestamp: timestamp, commit_sha: commit_sha, ci_build_url: ci_build_url)
    expect(build.timestamp).to eq(timestamp)
    expect(build.commit_sha).to eq(commit_sha)
    expect(build.ci_build_url).to eq(ci_build_url)
    
    hash = build.to_hash
    expect(hash[:timestamp]).to eq(timestamp)
    expect(hash[:commit_sha]).to eq(commit_sha)
    expect(hash[:ci_build_url]).to eq(ci_build_url)
    expect(hash[:reports]).to eq([])
    
    # add a couple of reports
    report1 = double('FakeReport', to_hash: { :text => 'fake report 1' })
    report2 = double('FakeReport', to_hash: { :text => 'fake report 2' })
    
    build.add_report(report1)
    build.add_report(report2)
    hash = build.to_hash
    expect(hash[:reports]).to eq([report1.to_hash, report2.to_hash])
  end
  
  it "doesn't like reports which can't be converted to a hash" do
    build = described_class.new(timestamp: timestamp, commit_sha: commit_sha, ci_build_url: ci_build_url)
    
    expect { build.add_report(2255) }.to raise_error("Reports must respond to to_hash")
  end
  
end