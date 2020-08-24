source $stdenv/setup

set -eo pipefail

xxd -i $src/ivory.pill > ivory.h

mkdir -p $out/include

mv ivory.h $out/include
