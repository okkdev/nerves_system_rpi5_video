{
  description = "Nerves development environment with FHS compatibility";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        otp = pkgs.beam.packages.erlang_28;
        fhs = pkgs.buildFHSEnv {
          name = "nerves-shell";

          targetPkgs =
            pkgs: with pkgs; [
              # Elixir / Erlang
              otp.erlang
              otp.rebar3
              otp.elixir_1_19

              # Nerves host tools
              fwup
              squashfsTools
              pkg-config
              curl
              wget
              git
              openssh

              # Buildroot hard dependencies
              file
              gnumake
              gcc
              binutils
              patch
              gzip
              bzip2
              xz
              perl
              python3
              cpio
              unzip
              rsync
              bc
              which
              ncurses
              ncurses.dev

              # Additional Buildroot deps
              openssl
              openssl.dev
              cmake
              automake
              autoconf
              libtool
              m4
              gettext
              flex
              bison
              texinfo

              # For menuconfig
              ncurses5

              # Misc
              libmnl
              zlib
              zlib.dev
            ];

          multiPkgs = null;

          profile = ''
            export LANG=en_US.UTF-8
            export MIX_TARGET=rpi5
            export ERL_AFLAGS="-kernel shell_history enabled"
          '';

          runScript = "bash";
        };
      in
      {
        devShells.default = fhs.env;
      }
    );
}
