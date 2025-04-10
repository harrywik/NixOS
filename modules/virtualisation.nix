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
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [(pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd];
        };
      };
    };
	};
}
