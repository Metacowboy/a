#!/bin/dash -e
# split album flac file

xc() {
  awk '
  BEGIN {
    x = "\47"
    printf "\33[36m"
    while (++i < ARGC) {
      y = split(ARGV[i], z, x)
      for (j in z) {
        printf z[j] ~ /[^[:alnum:]%+,./:=@_-]/ ? x z[j] x : z[j]
        if (j < y) printf "\\" x
      }
      printf i == ARGC - 1 ? "\33[m\n" : FS
    }
  }
  ' "$@" | fmt -80
  "$@"
}

if [ "$#" != 1 ]
then
  echo 'ff-split.sh [cue file]'
  exit
fi

awk '
$1 == "FILE" {
  split($0, i, /"/)
  file = i[2]
}
$1 == "TRACK" {
  tracks[++j] = $2
}
$1 == "TITLE" && j {
  split($0, i, /"/)
  titles[j] = i[2]
}
$1 == "INDEX" && $2 {
  split($3, i, ":")
  indexes[j] = sprintf("%d:%02d:%06.3f", i[1]/60, i[1]%60, i[2]+i[3]/75)
}
END {
  for (each in tracks) {
    print file
    print tracks[each]
    print titles[each]
    print indexes[each]
    print indexes[each+1]
  }
}
' "$1" |
while
  read file
  read track
  read title
  read start
  read stop
do
  xc ffmpeg -nostdin -v warning -stats -i "$file" \
  -ss $start ${stop:+-to $stop} -b:a 256k -movflags faststart \
  -metadata track=$track -metadata title="$title" "$track $title".m4a
done
