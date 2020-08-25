source $stdenv/setup

set -eo pipefail

mkdir -p $out/include

xxd -i $src > $out/include/ivory.h
