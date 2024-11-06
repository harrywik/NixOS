{ pkgs, ... }:
{
	# Required by podman for rootless mode
	security.unprivilegedUsernsClone = true;

	virtualisation = {
		containers.enable = true;
		podman = {
			enable = true;
			dockerSocket.enable = true;
			defaultNetwork.settings.dns_enabled = true;

		};
	};
}
