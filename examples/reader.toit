// Copyright (C) 2023 Toitware ApS.
// Use of this source code is governed by a Zero-Clause BSD license that can
// be found in the EXAMPLES_LICENSE file.

import ibutton
import gpio

READER-PIN ::= 18

main:
  reader := ibutton.Reader (gpio.Pin READER-PIN)

  last-id/int? := null
  while true:
    exception := catch:
      ibutton := reader.scan
      if not ibutton:
        last-id = null
      else if ibutton.id != last-id:
        print "Found: $ibutton"
        last-id = ibutton.id
    print "Caught: $exception"
    sleep --ms=200

  reader.close
