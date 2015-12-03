#!/usr/bin/env julia4

# Dependencies
# 7zip (Windows)

include("jl/julia-download.jl")

# Julia Packages

pkgname = "pkg"^20
mkpath("julia/pkg")
mv("julia/pkg", "julia/$pkgname")

try
  ENV["JULIA_PKGDIR"] = abspath("julia/$pkgname")
  @osx_only run(`julia/julia-$ver-mac/bin/julia -i --color=yes jl/packages.jl`)
  @windows_only run(`julia/julia-$ver-win64/bin/julia.exe -i jl/packages.jl`)
  delete!(ENV, "JULIA_PKGDIR")
finally
  mv("julia/$pkgname", "julia/pkg")
end

# Atom Build

isdir("out/juno") && rm("out/juno", recursive=true)

run(`node script/build --build-dir=out --no-install --channel=stable
                       --no-auto-update --julia-version=$ver`)
