require 'dpkg/ar'
require 'dpkg/package'
require 'dpkg/control'

module DPKG
  class << self
    def new(filename)
      Package.new(filename)
    end
  end
end
