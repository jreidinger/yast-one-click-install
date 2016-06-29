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

  private

    # remove from repositories one already in system
    def filter_out_used_repos
      Yast::SourceManager.ReadSources

      @repositories.delete_if do |repo|
        Yast::SourceManager.get_url_to_id[repo.url]
      end
    end

  end
end
