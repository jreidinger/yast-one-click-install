require "yast"

require "y2_oci/proposal_store"
require "installation/proposal_runner"

Yast.import "Wizard"

# Proposal runner expect already opened wizard dialog
Yast::Wizard.OpenNextBackDialog
begin
  ret = ::Installation::ProposalRunner.new(Y2OCI::ProposalStore).run
ensure
  Yast::Wizard.CloseDialog
end

ret
