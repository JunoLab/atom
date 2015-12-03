const require = ["Atom", "Gadfly"]

cachedir = Pkg.dir("..", "lib", "v$(VERSION.major).$(VERSION.minor)")

isdir(cachedir) && rm(cachedir, recursive = true)

Pkg.init()
Pkg.update()
for pkg in require
  Pkg.add(pkg)
  Base.require(symbol(pkg))
end

# Cache Preprocessing

function startswith!(io::IO, s)
  pos = position(io)
  for c in s
    if eof(io) || c ≠ read(io, UInt8)
      seek(io, pos)
      return false
    end
  end
  return true
end

startswith!(io::IO, s::UTF8String) = startswith!(io, s.data)

prefix = Pkg.dir()
dummy = "i sure hope this isn't in any packages"

function upto(io::IO)
  len = position(io)
  seek(io, 0)
  return readbytes(io, len)
end

cd(cachedir) do
  for cache in readdir()
    f = open(cache)
    Base.isvalid_cache_header(f) || continue
    Base.cache_dependencies(f)

    out = IOBuffer()
    write(out, upto(f))
    io = IOBuffer(readbytes(f))
    close(f)

    while !eof(io)
      if startswith!(io, prefix)
        write(out, rpad(dummy, length(prefix)))
      else
        write(out, read(io, UInt8))
      end
    end
    open(io -> write(io, takebuf_array(out)), cache, "w")
  end
end

exit()
