// Copyright (C) 2023 Toitware ApS.
// Use of this source code is governed by a Zero-Clause BSD license that can
// be found in the EXAMPLES_LICENSE file.

/**
Example that demonstrates how to modify the ID of an RW1990.

The program waits until it detects an iButton, and then
  changes the ID to one that starts with "0xDEADBEEF". If
  the iButton's ID already starts this way,  uses
  "0xCAFEBABE" instead.
*/

import ibutton
import gpio

READER-PIN ::= 18

main:
  reader := ibutton.Reader (gpio.Pin READER-PIN)

  while true:
    exception := catch:
      while not reader.scan:
        sleep --ms=200
      ibutton := reader.scan
      print "Found iButton: $ibutton"
      new-msb := 0xDEADBEEF
      new-lsb := random & 0xFFFFFFFF
      msb := ibutton.id >>> 32
      if msb == 0xDEADBEEF:
        new-msb = 0xCAFEBABE
      new-id := (new-msb << 32) | new-lsb
      print "updating ID to $(%x new-id)"
      ibutton.write-id new-id
      print "After: $ibutton"
      sleep --ms=2000
    if exception: print "Error: $exception"

  reader.close
