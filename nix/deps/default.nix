{ pkgs }:

rec {
  argon2       = import ./argon2       { inherit pkgs; };
  murmur3      = import ./murmur3      { inherit pkgs; };
  uv           = import ./uv           { inherit pkgs; };
  ed25519      = import ./ed25519      { inherit pkgs; };
  scrypt       = import ./scrypt       { inherit pkgs; };
  softfloat3   = import ./softfloat3   { inherit pkgs; };
  secp256k1    = import ./secp256k1    { inherit pkgs; };
  h2o          = import ./h2o          { inherit pkgs uv; };
  pills        = import ./pills        { inherit pkgs; };
  ivory-header = import ./ivory-header { inherit pkgs pills; };
  ca-header    = import ./ca-header    { inherit pkgs; };
}
