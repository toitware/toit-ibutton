// Copyright (C) 2023 Toitware ApS. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import gpio
import one_wire

/**
An iButton reader.

This class is a small wrapper around the 1-wire protocol.

It assumes that the reader is the only physical device that is attached
  to the bus. If the reader is not the only device, use the one_wire.Bus
  class directly.
*/
class Reader:
  bus_/one_wire.Bus

  /**
  Constructs a reader instance on the 1-wire bus on the given $pin.
  */
  constructor pin/gpio.Pin:
    bus_ = one_wire.Bus pin

  /**
  Scans the reader for an iButton.

  Performs a 1-wire bus reset, to which all devices on the bus must
    respond. If a device responds, it is assumed to be a single iButton.

  Returns null if no device responds to the bus reset.
  */
  scan -> IButton?:
    if not bus_.reset: return null
    // Assume that the responding device is an iButton.
    // We could verify the device family, but since this class is
    // really designed for iButtons, we don't bother.
    return IButton bus_ bus_.read_device_id

  /**
  Variant of $(scan).

  Only returns the device id, and does not create an IButton instance.
  */
  scan --id_only/bool -> int?:
    if not id_only: throw "INVALID_ARGUMENT"
    if not bus_.reset: return null
    return bus_.read_device_id

  /** Whether this reader is closed. */
  is_closed -> bool:
    return bus_.is_closed

  /** Closes this reader and the underlying bus. */
  close:
    bus_.close

/**
An iButton.

The iButton is a small, waterproof, and shock-resistant device that can be used
  to uniquely identify a person or object. The iButton is a hot-pluggable 1-wire device, and
  can be read using the 1-wire bus.
*/
class IButton:
  id/int
  bus_/one_wire.Bus

  /**
  Constructs an iButton instance.
  */
  constructor .bus_ .id:

  stringify -> string:
    return "IButton-$(%016x id)"
