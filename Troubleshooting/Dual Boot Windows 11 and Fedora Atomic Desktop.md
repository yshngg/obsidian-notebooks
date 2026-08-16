## Symptom

Failed to install Fedora Atomic Desktop on a PC that already has Windows installed.

## Fix

Install Fedora Atomic Desktop first, then install Windows.

**Or**

Create a dedicated ESP(EFI System Partition) for the Fedora Atomic Desktop installation

**Then**

Use the EFI firmware to switch between boot entries instead of using GRUB.

## References

- <https://docs.fedoraproject.org/en-US/atomic-desktops/installation/#known-limitations>
- <https://discussion.fedoraproject.org/t/state-of-dual-booting-atomic-desktops-windows/147408>
- <https://forge.fedoraproject.org/atomic-desktops/tracker/issues/110>
- <https://github.com/fedora-silverblue/issue-tracker/issues/284>
