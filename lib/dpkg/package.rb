require 'rubygems/package'
require 'zlib'
require 'archive/ar'
require 'stringio'

module DPKG
  class Package
    def initialize(filename)
      @filename = filename
    end

    def read_control_tar_gz
      Archive::Ar.traverse(@filename) do |header, data|
        if header[:name] == "control.tar.gz"
          return data
        end
      end
    end

    def ungzip(data)
      io = StringIO.new(data)
      gz = Zlib::GzipReader.new(io)
      out = StringIO.new(gz.read)
      gz.close
      out
    end

    def control
      Control.new(self)
    end

    def control_data
      ct = read_control_tar_gz
      data = ungzip(ct)

      Gem::Package::TarReader.new data do |tar|
        tar.each do |tarfile|
          if tarfile.full_name == "./control"
            return tarfile.read
          end
        end
      end
    end
  end
end
