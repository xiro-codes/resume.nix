from nixos/nix:latest as stage1
COPY ./ /pkg
WORKDIR /pkg
RUN nix --extra-experimental-features nix-command --extra-experimental-features flakes build
ENTRYPOINT [ "/bin/sh" ]