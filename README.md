# iButton

A library to interact with iButtons, such as the DS1990A.

This library also supports the RW1990 which can modify the ID of the iButton.

![iButton](pics/ibutton.jpg)

## Connections
Typically, the readers have two wires, one for data/power and one for ground. The
1-wire protocol expects the data wire to be pulled up to power by a resistor.

In most cases, the pull-up of the ESP32 is strong enough to power devices that
are connected to the 1-wire bus. As such, no additional components are needed.

See https://pdfserv.maximintegrated.com/en/an/AN4255.pdf for more information on
how to power 1-wire devices.

## RW1990 support
The RW1990 is a device that allows to modify the ID of an iButton. It is not
produced by Dallas, but can be found on Chinese websites.

We were not able to reliable change all RW1990 devices we received. Out of
10 devices, 4 worked without issues, 4 did not allow to change the IDs at all,
and 2 had some bits that could not be changed.

## Trademarks
The iButton name and logo are trademarks of Maxim Integrated Products, Inc.

The 1-wire name and logo are trademarks of Maxim Integrated Products, Inc.
