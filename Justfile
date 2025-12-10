# vim: set filetype=make:

default:
    @just --list --unsorted

_update-meta:
	#!/usr/bin/env nu
	let meta = open meta.toml
	let meta = $meta | update location (pwd)
	let meta = $meta | upsert publicKeys {|x| $x.publicKeys? | append (open --raw ~/.ssh/id_ed25519.pub | str trim) | uniq }
	$meta | save -f meta.toml

_generate-hardware-config name:
	#!/usr/bin/env nu
	mkdir ./hosts/{{ name }}
	nixos-generate-config --no-filesystems --show-hardware-config
		| save -f ./hosts/{{ name }}/hardware-configuration.nix

# Add new system to meta.toml
add ip="127.0.0.1":
	#!/usr/bin/env nu
	just _update-meta
	gum confirm "Are you sure you want to add the machine at {{ ip }}?"
	let disk = ssh root@{{ ip }} "lsblk" | detect columns | each {|r| $"($r.NAME) : ($r.SIZE)"} | to text | gum choose --header="Please choose what disk you want to use:" | split column " : " | get column1.0 | str trim
	let name = gum input --header="What is the name of the machine?"
	let headless = (gum choose "use niri wayland compositor" "headless" --header="Is this machine headless (No GUI)?") == "headless"
	let system = (ssh root@{{ ip }} "uname -m") + "-linux"

	let row = {name: $name, disk: $disk, system: $system, headless: $headless}

	print $row
	gum confirm "Do you want to add this machine to the list?"
	open meta.toml | upsert hosts {|x| $x.hosts | append $row } | save -f meta.toml
	print $"Added machine ($name) to meta.toml, to install it run `just install ($name) [optional IP]`"

# Install the system either remotely or locally
install name ip="local":
	#!/usr/bin/env nu
	just _update-meta

	def local_install [] {
		gum confirm "You will install the distro on the local machine, is this correct?"
		just _generate-hardware-config {{ name }}
		(
			sudo nix --experimental-features "nix-command flakes"
				run github:nix-community/disko/latest --
					--mode destroy,format,mount
					--flake ".#{{ name }}"
		)
		sudo nixos-install --root /mnt --flake ".#{{ name }}"
	}

	def remote_install [ip] {
		gum confirm $"You will install the distro remotely on '($ip)', is this correct?"
		(
			nix run github:nix-community/nixos-anywhere --
				--flake ".#{{ name }}"
				--generate-hardware-config nixos-generate-config ./generated-hardware-configuration.nix
				--build-on remote
				$"root@($ip)"
		)
	}

	if ("{{ ip }}" == 'local') {
		local_install
	} else {
		remote_install "{{ ip }}"
	}


[confirm]
setup-dotfiles:
	#!/usr/bin/env nu
	just _update-meta
	^mkdir -p ~/.config
	let files = [
		"nvim",
		"zellij",
		"tmux",
		"presenterm",
		"niri",
		"nushell",
		"kitty",
		"qutebrowser",
		"quickshell",
	]

	for file in $files {
		let src = $"./configs/($file)" | path expand -n
		let dest = $"~/.config/($file)" | path expand -n
		print $"Setting symlink '(ansi blue)($src)(ansi reset)' to '(ansi blue)($dest)(ansi reset)'"
		rm --force -r $dest
		ln -s $src $dest
	}
	print $"Setting symlink '(ansi blue)./configs/wallpaper.png(ansi reset)' to '(ansi blue)~/wallpaper(ansi reset)'"
	rm --force -r ~/wallpaper
	ln -s ("./configs/wallpaper.png" | path expand -n) ("~/wallpaper" | path expand -n)
	print $"(ansi green)Successfully added symlinks(ansi reset)"


switch:
	#!/usr/bin/env nu
	if (git status --porcelain | is-not-empty) {
		print $"(ansi red_bold)Need to commit changes before switching, try `just quick-switch` if you need quick changes(ansi reset)"
		exit 0
	}
	# nix-rebuild switch --flake . e>| nom
	just quick-switch

quick-switch:
	#!/usr/bin/env bash
	just _update-meta
	sudo -v
	sudo -n nixos-rebuild switch --flake . --log-format internal-json -v |& nom --json

# Garbage collection
gc:
	sudo nix-collect-garbage --delete-old	# Delete old OS stuff
