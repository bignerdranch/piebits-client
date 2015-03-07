module Piebits

  class Build
    attr_reader :timestamp
    attr_reader :commit_sha
    attr_reader :reports
    attr_reader :ci_build_url

    def initialize(timestamp:, commit_sha:, ci_build_url:)
      @timestamp = timestamp
      @commit_sha = commit_sha
      @ci_build_url = ci_build_url
      @reports = []
    end

    def add_report(report)
      fail "Reports must respond to to_hash" unless report.respond_to?(:to_hash)
      @reports << report
    end

    def to_hash
      {
        :timestamp => timestamp,
        :commit_sha => commit_sha,
        :ci_build_url => ci_build_url,
        :reports => reports.map(&:to_hash)
      }
    end
  end

end
