require "installation/proposal_client"
require "y2_oci/repository_manager"

module Y2OCI
  module Clients
    class RepositoriesProposal < ::Installation::ProposalClient
      def initialize
        textdomain "one-click-install"
      end

      def make_proposal(_attrs)
        RepositoryManager.instance.sync_repos_to_system

        {
          "preformatted_proposal" => repositories_summary,
          "help"                  => help
        }
      end

      def ask_user(param)
        if param == "repositories_proposal"
          # support clicking on it
          { "workflow_sequence" => :next }
        else
          RepositoryManager.instance.repositories.delete_if{ |r| r.url = param }
        end
      end

      def description
        {
          # TRANSLATORS: a summary heading
          "rich_text_title" => _("Repositories Summary"),
          # TRANSLATORS: a menu entry
          "menu_title"      => _("&Repositories Summary"),
          "id" => "repositories_proposal"
        }
      end

    private

      def help
        _("<p>This is the overview for repositories installed by one click install</p>")
      end

      def repositories_summary
        repo_list = RepositoryManager.instance.repositories.map do |repo|
          repo.name + "<a href=\"#{repo.url}\">remove</a>"
        end

        _("Repositories to add: <ul><li>") + repo_list.join("</li><li>") + "</li></ul>"
      end
    end
  end
end
