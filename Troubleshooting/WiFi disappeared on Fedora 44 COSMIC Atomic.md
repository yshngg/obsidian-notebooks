## Symptom

WiFi disappeared on Fedora 44 COSMIC Atomic(ASUS TX GAMING B760M WIFI, Intel AX201).

## Root Cause

Windows Fast Startup left the AX201 in a locked/low-power state. The Linux iwlwifi driver could not initialize it, so probing timed out (-110). Windows' driver could recover it, which is why Windows worked.

[Distinguishing fast startup from wake-from-hibernation](https://learn.microsoft.com/en-us/windows-hardware/drivers/kernel/distinguishing-fast-startup-from-wake-from-hibernation)

[Fast Startup from a Low-Power State](https://learn.microsoft.com/en-us/windows-hardware/drivers/kernel/fast-startup-from-a-low-power-state)

## Fix

### Temporarily

A full power drain (30s).

Or

### Permanently

Disabled Fast Startup in Windows.

[How to turn off Windows Fast Startup and what problems it may cause](https://www.howtogeek.com/why-windows-fast-startup-causes-problems-and-how-to-turn-it-off-safely/)

## References

- Reddit: AX201 locked by Fast Startup (https://reddit.fsky.io/r/linuxquestions/comments/1tzb8v5/wifi_not_working_on_ubuntu_cachyos_intel_wifi_6/)
- Fedora Forum: same iwlwifi -110 case (https://discussion.fedoraproject.org/t/wifi-not-working-on-dell-latitude-5420-intel-ax201-device-is-unclaimed/169425/4)
- Launchpad #2129027: D3cold device inaccessible (https://bugs.launchpad.net/ubuntu/+source/linux-oem-6.14/+bug/2129027)
- [Linux Mint Forums: How does Windows fast boot disrupt Mint WiFi drivers?](https://forums.linuxmint.com/viewtopic.php?t=436594)
