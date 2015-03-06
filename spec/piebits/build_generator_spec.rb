require 'spec_helper'

describe Piebits::BuildGenerator do
  let(:environment) {
    {
      "TRAVIS_BUILD_ID" => "12351325",
      "TRAVIS_COMMIT" => "abcd1234",
      "TRAVIS_REPO_SLUG" => "bignerdranch/piebits",
      "TRAVIS" => "true"
    }
  }
  let(:working_dir) {
    File.join(__dir__, "../fixtures")
  }
  let(:config_filename) {
    File.join(working_dir, "config-with-oclint.yml")
  }
  
  it "can be initialized with environment and configuration filename" do
    build_generator = described_class.new(environment, working_dir, config_filename)
    expect(build_generator.environment).to eq(environment)
    expect(build_generator.configuration).to eql(Piebits::Configuration.new(YAML.safe_load(IO.read(config_filename))))
  end
  
  it "can generate a build" do
    build_generator = described_class.new(environment, working_dir, config_filename)
    build = build_generator.generate_build
    
    expected_build_hash = {
      timestamp: nil, # TODO
      commit_sha: environment["TRAVIS_COMMIT"],
      ci_build_url: nil, # TODO
      reports: [
        {
          tool_name: "oclint",
          tool_version: nil, # TODO?
          category: "analysis",
          data: "fake oclint json" 
        }
      ]
    }
    # :commit_sha
    expect(build.commit_sha).to eq(environment["TRAVIS_COMMIT"])

    expect(build.to_hash).to eq(expected_build_hash)
  end
end