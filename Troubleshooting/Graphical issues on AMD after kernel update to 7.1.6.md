## Symptom

Graphical artifacts on Fedora 44 COSMIC Atomic(AMD Radeon 9070).

https://github.com/pop-os/cosmic-epoch/issues/3784

## Debug

There are no issues using the GNOME desktop environment, or using the integrated graphics card.

## Root Cause

https://bugzilla.redhat.com/show_bug.cgi?id=2512106

## Blast Radius

Linux kernel version 7.1.6 and 7.1.7.

Have been fixed in 7.1.8.

## Fix

Upgrade the kernel to version 7.1.8 or higher, or downgrade it to version 7.1.5 or lower.

https://discussion.fedoraproject.org/t/graphical-issues-on-amd-after-kernel-update-to-7-1-6/198522/41

Or

Use the integrated graphics card if any.

## References

[[Trying different desktop environments]]
