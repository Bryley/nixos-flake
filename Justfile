# vim: set filetype=make:

system := `nix eval --impure --raw --expr 'builtins.currentSystem'`
generation := `sudo nix-env --list-generations -p /nix/var/nix/profiles/system | grep current | awk '{print "Generation", $1}'`


default:
    @just --list --unsorted


# Generates files inside `host` dir for current system
gen-new-host host-name:
    #!/usr/bin/env sh
    if [ ! -e /run/current-system ]; then
        echo "Running in live ISO mode"
        nixos-generate-config --root /mnt --dir ./hosts/{{host-name}}
    else
        echo "Running on an installed system"
        nixos-generate-config --dir ./hosts/{{host-name}}
    fi
    echo -e "\nFinished generating, in order to use this host please add the following line inside of \`nixosConfigurations\` inside of 'flake.nix':\n"
    echo -e "    {{host-name}} = mkSystem { hostname=\"{{host-name}}\"; system=\"{{system}}\"; };\n"


# Garbage collection
gc:
	sudo nix-collect-garbage --delete-old	# Delete old OS stuff
	nix-collect-garbage --delete-old		# Delete Home Manager


switch:
	-git commit -am "{{generation}}"
	nh os switch .
	just home
	-git push


home user='bryley':
	-git add .
	nh home switch . --configuration {{user}}-{{system}}
