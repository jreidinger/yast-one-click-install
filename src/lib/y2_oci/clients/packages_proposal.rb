require "installation/proposal_client"
require "y2_oci/instructions"

module Y2OCI
  module Clients
    class PackagesProposal < ::Installation::ProposalClient
      def initialize
        textdomain "one-click-install"
      end

      def make_proposal(_attrs)
        {
          "preformatted_proposal" => packages_summary,
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
          "rich_text_title" => _("Packages Summary"),
          # TRANSLATORS: a menu entry
          "menu_title"      => _("&Packages Summary"),
          "id" => "packages_proposal"
        }
      end

    private

      def help
        _("<p>This is the overview for packages installed by one click install</p>")
      end

      def packages_summary
        _("Package to install: ") + Y2OCI::Instructions.instance.packages.map(&:name).join(", ")
      end
    end
  end
end
