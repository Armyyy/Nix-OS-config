{ pkgs, ... }:
{
  home.packages = with pkgs; [
    qemu_kvm
    virt-manager
    virt-viewer
  ];
}
