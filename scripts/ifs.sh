# find a good character to use for IFS

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

log ()
{
  unset PS4
  set $((set -x; : "$@") 2>&1)
  shift
  warn $*
  eval $*
}

chars=(
  20 21 22 23 24 25 26 27 28 29 2A 2B 2C 2D 2E 2F
  3A 3B 3C 3D 3E 3F 40
  5B 5C 5D 5E 5F 60
  7B 7C 7D 7E
)

for char in "${chars[@]}"
do
  printf -v foo "\x$char"
  log declare bar="$foo"
done
