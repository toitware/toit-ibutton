// Copyright (C) 2023 Toitware ApS. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import gpio
import one-wire

/**
An iButton reader.

This class is a small wrapper around the 1-wire protocol.

It assumes that the reader is the only physical device that is attached
  to the bus. If the reader is not the only device, use the one_wire.Bus
  class directly.
*/
class Reader:
  bus_/one-wire.Bus

  /**
  Constructs a reader instance on the 1-wire bus on the given $pin.

  If $pull-up is true, uses the pin's internal pull-up resistor to provide
    power to the bus.
  */
  constructor pin/gpio.Pin --pull-up/bool=true:
    bus_ = one-wire.Bus pin --pull-up=pull-up

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
    return IButton bus_ bus_.read-device-id

  /**
  Variant of $(scan).

  Only returns the device id, and does not create an IButton instance.
  */
  scan --id-only/bool -> int?:
    if not id-only: throw "INVALID_ARGUMENT"
    if not bus_.reset: return null
    return bus_.read-device-id

  /** Whether this reader is closed. */
  is-closed -> bool:
    return bus_.is-closed

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
  static COMMAND-WRITE-SERIAL_ ::= 0xD5

  id_/int := ?
  bus_/one-wire.Bus

  /**
  Constructs an iButton instance.
  */
  constructor .bus_ .id_:

  id -> int: return id_

  stringify -> string:
    return "IButton-$(%016x id_)"

  /**
  Writes the given $id to the iButton.

  The device must have a changeable ID. A typical device would be the RW1990.

  Depending on the version of the RW1990, the ID bits must be written in
    inverse order. In that case use the $inverse flag.
  */
  write-id id/int --inverse/bool=false:
    if inverse:
      tmp := id
      id = 0
      64.repeat:
        id = (id << 1) | (tmp & 1)
        tmp >>= 1

    bus_.read-device-id

    if not bus_.reset: throw "NO_DEVICE"
    bus_.write-byte 0xD1 --activate-power  // Unlock write.
    bus_.write-bit 0 --activate-power
    sleep --ms=10

    if not bus_.reset: throw "NO_DEVICE"
    // Initiate writing the ID.
    bus_.write-byte COMMAND-WRITE-SERIAL_ --activate-power
    64.repeat:
      // The bits are written inverted.
      bus_.write-bit (~id & 1) --activate-power
      id >>= 1
      sleep --ms=10

    // Lock write.
    if not bus_.reset: throw "NO_DEVICE"
    bus_.write-byte 0xD1 --activate-power
    bus_.write-bit 1 --activate-power

    id_ = bus_.read-device-id
