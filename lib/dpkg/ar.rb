module DPKG
  class AR
    def initialize(filename)
      @filename = filename
    end

    def file
      @file ||= File.new(@filename)
    end

    def read(entry)
      f = File.new(@filename)
      f.seek(entry[:start])
      f.read(entry[:size])
    end

    def files
      read_global_header
      done = false
      list = []

      while done == false do
        data = read_header
        break unless data
        break if data.length < 60
        entry = {
          :name => data[0,16].strip,
          :mod_time => data[16,12].to_i,
          :owner => data[28,6].to_i,
          :group => data[34,6].to_i,
          :mode => data[40,8].strip,
          :size => data[48,10].to_i,
          :magic => data[58,2],
          :start => file.tell
        }

        if entry[:magic] == "\x60\x0a"
          list << entry
          file.seek(entry[:size], IO::SEEK_CUR)
        else
          done = true 
        end
      end

      list
    end

    def read_global_header
      raise "Invalid Global Header" unless file.read(8) == "!<arch>\n"
    end

    def read_header
      file.read(60)
    end
  end
end
