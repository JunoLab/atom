mkpath("julia")

aws(x) = "https://s3.amazonaws.com/julialang/$x"

const ver = v"0.4.3"

download(x) = !isfile(basename(x)) && Base.download(x, basename(x))

cd("julia") do

@windows_only begin
  for arch in ["32", "64"]
    name = "julia-$ver-win$arch"
    if !isdir(name)
      folder = arch == "32" ? "86" : arch
      download(aws("bin/winnt/x$folder/$(ver.major).$(ver.minor)/$name.exe"))
      run(`7z x $name.exe`)
      run(`7z x julia-installer.exe`)
      rm("julia-installer.exe")
      rm("\$PLUGINSDIR", recursive = true)
      rm("LICENSE.md")
      mv("\$_OUTDIR", name)
    end
  end
end

@osx_only begin
  name = "julia-$ver-mac"
  if !isdir(name)
    download(aws("bin/osx/x64/$(ver.major).$(ver.minor)/julia-$ver-osx10.7+.dmg"))
    run(`hdiutil attach julia-$ver-osx10.7+.dmg`)
    run(`cp -r /Volumes/Julia/Julia-$ver.app/Contents/Resources/julia $name`)
    run(`hdiutil detach /Volumes/Julia`)
  end
end

end
