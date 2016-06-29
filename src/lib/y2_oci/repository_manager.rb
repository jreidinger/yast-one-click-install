require "yast"

require "y2_oci/instructions"

Yast.import "SourceManager"

module Y2OCI
  class RepositoryManager
    include Singleton

    attr_reader :repositories
    attr_reader :package

    def load_instructions(path)
      @instructions = Instructions.new(path)

      @repositories = @instructions.repositories.dup
      @package = @instructions.packages.first.dup

      filter_out_used_repos
    end

    def sync_repos_to_system
      @added_repos ||= []

      @added_repos.each do |repo|
        Yast::SourceManager.deleteSourceBySrcId(Yast::SourceManager.getSourceId(repo.url))
      end

      @added_repos = []

      @repositories.each do |repo|
        res = Yast::SourceManager.createSource(repo.url)
        @added_repos << repo if res == :ok
      end

      Yast::SourceManager.CommitSources
    end

  private

    # remove from repositories one already in system
    def filter_out_used_repos
      Yast::SourceManager.ReadSources

      @repositories.delete_if do |repo|
        Yast::SourceManager.getSourceId(repo.url) != -1
      end
    end

  end
end
