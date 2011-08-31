class Object
    def backtrace
        raise
    rescue Exception => x
        x.backtrace[1..-1]  # Leave off first line since we don't care about it
    end
end
