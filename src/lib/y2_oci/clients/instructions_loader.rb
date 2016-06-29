require "yast"

require "y2_oci/repository_manager"

Yast.import "Report"

module Y2OCI
  module Clients
    class InstructionsLoader
      extend Yast::I18n

      def self.run(instruction_file)
        textdomain "one-click-install"
        if !instruction_file
          Yast::Report.Error(_("Missing ymp file."))
          return false
        end

        begin
          RepositoryManager.instance.load_instructions(instruction_file)
        rescue => e
          Yast::Report.Error(_("Failed to load ymp file.\n#{e.message}"))
          return false
        end

        true
      end
    end
  end
end

