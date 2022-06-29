DISTROS_DIR=distros
DISTRO_ACTIVE_LINK=distro-active

# A literal space.
space :=
space +=

join-with = $(subst $(space),$1,$(strip $2))

generate-help = sed -n -e 's/^\# help: \(.*\)/\1/;t z' -e b -e ':z' \
	-e 'N;s/'\'/\'\\\\\'\'/g \
	-e 's/\(.*\)\n\([^:]*\):.*/printf "%-20s - %s\\n" '\''\2'\'' '\''\1'\''/p' $1 | sh

# vim: noexpandtab tabstop=4 shiftwidth=4 fileformat=unix
