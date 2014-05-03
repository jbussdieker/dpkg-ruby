module DPKG
  class Control
    def initialize(package)
      @package = package
    end

    def name
      control_data.match(/^Package:\s*([^\n]*)$/).captures.first
    end

    def version
      control_data.match(/^Version:\s*([^\n]*)$/).captures.first
    end

    def control_data
      @control_data ||= @package.control_data
    end
  end
end
