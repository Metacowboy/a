# ffmpeg remux to format of choice

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

unquote ()
{
  read -r $1 <<< "${!1//\"}"
}

usage ()
{
  echo usage: $0 FORMAT
  exit
}

path ()
{
  cd "${!1%\\*}"
  read $1 <<< "${PWD}/${!1##*\\}"
  cd ~-
}

[ $1 ] || usage
arg_fmt=$1
flac=nocopy
wav=nocopy

if ! [ ${!arg_fmt} ]
then
  cpy='-c copy'
fi

printf -v nwn '\n'
while read -rp "Drag file here, or use a pipe.$nwn" inf
do
  [[ $inf ]] || exit
  unquote inf
  otf=${inf%.*}.${arg_fmt}
  # Stefano Sabatini broke "-nostdin"
  log ffmpeg -i "$inf" -v warning -stats $cpy "$otf" </dev/null
  path inf
  log rm "$inf"
done
