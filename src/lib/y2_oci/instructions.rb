require "rexml/document"
require "rexml/xpath"

require "y2_oci/repository"
require "y2_oci/package"

module Y2OCI
  class Instructions
    attr_reader :repositories, :packages

    class << self
      attr_reader :instance

      def load(instruction_file)
        @instance = new(instruction_file)
      end
    end

    def initialize(instruction_file)
      File.open(instruction_file) do |f|
        @document = REXML::Document.new(f)
      end

      @repositories = load_repositories
      @packages = load_packages
    end

  private

    def load_repositories
      repositories = []

      REXML::XPath.each( @document, "//repository" ) do |element|
        name = element.elements["name"].text
        summary = element.elements["summary"].text
        description = element.elements["description"].text
        url = element.elements["url"].text
        recommended = element.attributes["recommended"] == "true"
        repositories << Repository.new(name, summary, description, url, recommended)
      end

      repositories
    end

    def load_packages
      packages = []

      REXML::XPath.each( @document, "//software/item" ) do |element|
        name = element.elements["name"].text
        summary = element.elements["summary"].text
        description = element.elements["description"].text
        packages << Package.new(name, summary, description)
      end

      packages
    end
  end
end
