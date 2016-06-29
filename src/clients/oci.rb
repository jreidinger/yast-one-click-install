require "yast"
require "y2_oci/clients/main"

Y2OCI::Clients::Main.run(Yast::WFM.Args(0))
