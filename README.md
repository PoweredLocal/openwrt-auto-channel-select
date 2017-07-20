# openwrt-auto-channel-select
Automatic Wi-Fi channel selection script for OpenWRT and supported systems

## Overview

This little script will scan wireless networks around you and pick the best (least congested) frequency channel (1, 6 or 11).
It relies on ```iw [device] scan``` and it makes several scans with delays between them for increased accuracy.

## Usage

```bash
$ ./setAutoChannel.sh [interface index]
```

Where interface index is the index number of the wireless interface you are insterested in (eg. if you want to pick a channel for wlan0, pass 0 here)

After the best channel is found, this script will commit a config change using UCI, assuming that your radio interface has the same index (wlan0 -> radio0).

## Default settings

By default this script makes 3 scans with 5 second delay between them. You can change this at the top of the script.

## LICENSE

MIT License

Copyright (c) 2017 PoweredLocal https://www.poweredlocal.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
