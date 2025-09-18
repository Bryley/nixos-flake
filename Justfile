# vim: set filetype=make:

# system := `nix eval --impure --raw --expr 'builtins.currentSystem'`
# generation := `sudo nix-env --list-generations -p /nix/var/nix/profiles/system | grep current | awk '{print "Generation", $1}'`
# hostname := `sudo cat /etc/hostname`


default:
    @just --list --unsorted


# TODO add readme saying requirements are nushell and gum

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
	let headless = (gum choose "headless" "not-headless" --header="Is this machine headless (No GUI)?") == "headless"
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
		just _generate-hardware-config
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





# # Generates files inside `host` dir for current system
# gen-new-host host-name:
#     #!/usr/bin/env sh
#     if [ ! -e /run/current-system ]; then
#         echo "Running in live ISO mode"
#         nixos-generate-config --root /mnt --dir ./hosts/{{host-name}}
#     else
#         echo "Running on an installed system"
#         nixos-generate-config --dir ./hosts/{{host-name}}
#     fi
#     echo -e "\nFinished generating, in order to use this host please add it inside of flake.nix:\n"
#
#
# # Garbage collection
# gc:
#	sudo nix-collect-garbage --delete-old	# Delete old OS stuff
#	nix-collect-garbage --delete-old		# Delete Home Manager
#
#
# switch:
#	-git add .
#	nh os switch .
#	just home
#	-git commit -am "{{hostname}} - {{generation}}"
#	-git push
#
#
# home user='bryley':
#	-git add .
#	# TODO this is broken for some reason, seems to ignore the --configuration, maybe try a few versions later
#	# nh home switch . --configuration {{user}}-{{system}}
#	home-manager switch --flake .#{{user}}-{{system}}
