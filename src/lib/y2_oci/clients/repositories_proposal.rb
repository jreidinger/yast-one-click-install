require "installation/proposal_client"
require "y2_oci/repository_manager"

module Y2OCI
  module Clients
    class RepositoriesProposal < ::Installation::ProposalClient
      def initialize
        textdomain "one-click-install"
      end

      def make_proposal(_attrs)
        {
          "preformatted_proposal" => repositories_summary,
          "help"                  => help
        }
      end

      def ask_user(param)
        # TODO support clicking on it
        { "workflow_sequence" => :next }
      end

      def description
        {
          # TRANSLATORS: a summary heading
          "rich_text_title" => _("Repositories Summary"),
          # TRANSLATORS: a menu entry
          "menu_title"      => _("&Repositories Summary"),
          "id" => "packages_proposal"
        }
      end

    private

      def help
        _("<p>This is the overview for repositories installed by one click install</p>")
      end

      def repositories_summary
        _("Repositories to add: <ul><li>") +
         Y2OCI::RepositoryManager.instance.repositories.map(&:name).join("</li><li>") +
         "</li></ul>"
      end
    end
  end
end
