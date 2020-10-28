USER := jboyens
HOST := kitt
HOME := /home/$(USER)

NIXOS_VERSION := 20.09
NIXOS_PREFIX  := $(PREFIX)/etc/nixos
COMMAND       := test
FLAGS         := -I "config=$$(pwd)/config" \
				 -I "modules=$$(pwd)/modules" \
				 -I "bin=$$(pwd)/bin" \
				 $(FLAGS)

# The real Labowski
all: channels
	@sudo nixos-rebuild $(FLAGS) $(COMMAND) --show-trace

install: channels update config move_to_home
	@sudo nixos-install --root "$(PREFIX)" $(FLAGS)

upgrade: update switch

update: channels
	@sudo nix-channel --update

switch:
	@sudo nixos-rebuild $(FLAGS) switch

build:
	@sudo nixos-rebuild $(FLAGS) build

boot:
	@sudo nixos-rebuild $(FLAGS) boot

rollback:
	@sudo nixos-rebuild $(FLAGS) --rollback $(COMMAND)

dry:
	@sudo nixos-rebuild $(FLAGS) dry-build

gc:
	@nix-collect-garbage -d

vm:
	@sudo nixos-rebuild $(FLAGS) build-vm

clean:
	@rm -f result

repl:
	@nix repl $(FLAGS) '<nixpkgs>' '<nixpkgs/nixos>'


# Parts
config: $(NIXOS_PREFIX)/configuration.nix
move_to_home: $(HOME)/.dotfiles

channels:
	@sudo nix-channel --add "https://nixos.org/channels/nixos-20.09" nixos
	@sudo nix-channel --add "https://nixos.org/channels/nixos-unstable" nixos-unstable
	@sudo nix-channel --add "https://github.com/rycee/home-manager/archive/release-20.09.tar.gz" home-manager
	@sudo nix-channel --add "https://nixos.org/channels/nixpkgs-unstable" nixpkgs-unstable
	@sudo nix-channel --add "https://github.com/NixOS/nixos-hardware/archive/master.tar.gz" nixos-hardware

$(NIXOS_PREFIX)/configuration.nix:
	@sudo nixos-generate-config --root "$(PREFIX)"
	@echo "import /etc/dotfiles \"$${HOST:-$$(hostname)}\" \"$$USER\"" | sudo tee "$(NIXOS_PREFIX)/configuration.nix"
	@[ -f machines/$(HOST).nix ] || echo "WARNING: hosts/$(HOST)/default.nix does not exist"

$(HOME)/.dotfiles:
	@mkdir -p $(HOME)
	@[ -e $(HOME)/.dotfiles ] || sudo mv /etc/dotfiles $(HOME)/.dotfiles
	@[ -e /etc/dotfiles ] || sudo ln -s $(HOME)/.dotfiles /etc/dotfiles
	@chown $(USER):users $(HOME) $(HOME)/.dotfiles

# Convenience aliases
i: install
s: switch
up: upgrade


.PHONY: config
