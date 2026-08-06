
https://docs.fedoraproject.org/en-US/atomic-desktops/troubleshooting/#_adding_external_package_repositories

This section discusses third-party software sources not officially affiliated with or endorsed by the Fedora Project. Use them at your own discretion.

> If you want to use RPM Fusion repositories, please follow the [Enabling RPM Fusion repos](https://docs.fedoraproject.org/en-US/atomic-desktops/tips-and-tricks/#_enabling_rpm_fusion_repos) section.

Some sofware may only be available from a third-party repository. You can add an external repository manually on Fedora Atomic Desktops by placing the `.repo` file into `/etc/yum.repos.d/` and the GPG key into `/etc/pki/rpm-gpg/`. The following is a full example for setting up the Taiscale repo:

1. Fetch and install the repo config:
	```
	$ curl -O https://pkgs.tailscale.com/stable/fedora/tailscale.repo
	[tailscale-stable]
	name=Tailscale stable
	baseurl=https://pkgs.tailscale.com/stable/fedora/$basearch
	enabled=1
	type=rpm
	repo_gpgcheck=1
	gpgcheck=0
	gpgkey=https://pkgs.tailscale.com/stable/fedora/repo.gpg
	$ sudo install -o 0 -g 0 -m644 tailscale.repo /etc/yum.repos.d/tailscale.repo
	```
2. Fetch and install the GPG keys:
	```bash
	$ curl -O https://pkgs.tailscale.com/stable/fedora/repo.gpg
	$ sudo install -o 0 -g 0 -m644 repo.gpg /etc/pki/rpm-gpg/tailscale.gpg
	```
3. Replace the `gpgkey=` URL in the repo config by the path the GPG keys:
	```
	$ sudoedit /etc/yum.repos.d/tailscale.repo
	$ cat /etc/yum.repos.d/tailscale.repo
	[tailscale-stable]
	name=Tailscale stable
	baseurl=https://pkgs.tailscale.com/stable/fedora/$basearch
	enabled=1
	type=rpm
	repo_gpgcheck=1
	gpgcheck=0
	### Update this line
	gpgkey=file:///etc/pki/rpm-gpg/tailscale.gpg
	###    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	```
4. Install the new packages with:
	```
	$ rpm-ostree install tailscale
	```

Better support in `rpm-ostree` for this use case is tracked in [rpm-ostree#4014](https://github.com/coreos/rpm-ostree/issues/4014).

