// Copyright (C) 2023 Toitware ApS.
// Use of this source code is governed by a Zero-Clause BSD license that can
// be found in the EXAMPLES_LICENSE file.

import ibutton
import gpio

READER_PIN ::= 32

main:
  reader := ibutton.Reader (gpio.Pin READER_PIN)

  last_id/int? := null
  while true:
    ibutton := reader.scan
    if not ibutton:
      last_id = null
    else if ibutton.id != last_id:
      print "Found: $ibutton"
      last_id = ibutton.id
    sleep --ms=200

  reader.close
