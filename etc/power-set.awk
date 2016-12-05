#!/usr/bin/awk -f
function al(br, ch, de) {
  while (br) {
    ch--
    if (br % 2)
      de = de sprintf("%c ", 49 + ch)
    br = int(br / 2)
  }
  return de
}
{
  for (ec = 0; ec <= 2 ^ NF - 1; ec++) {
    print ec == 0 ? "empty" : al(ec, NF)
  }
}