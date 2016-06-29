require "yast"

require "y2_oci/clients/instructions_loader"

Yast.import "Report"

module Y2OCI
  module Clients
    class Main
      include Yast::I18n

      def self.run(instruction_file)
        return unless InstructionsLoader.run(instruction_file)

        proposal_ret =  Yast::WFM.CallFunction("oci_proposals", [{ "hide_export" => true }])

        return if proposal_ret != :next
      end
    end
  end
end
