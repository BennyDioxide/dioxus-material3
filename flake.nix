{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
          config.allowUnfree = true;
        };
      in
      {
        devShell = with pkgs; mkShell {
          packages = [ dioxus-cli ];
          nativeBuildInputs = [ pkg-config ];
          buildInputs = [
            rust-bin.stable.latest.default

            openssl
            # glibc
            # cairo
            # atk
            # pango
            # harfbuzz
            # gdk-pixbuf
            # gtk3 # gdk3
            webkitgtk_4_1 # javascriptcore

            # libsoup_3
            # libappindicator-gtk3
            # librsvg
            # vips
            xdotool
          ];
        };
      }
    );
}
