let
  sshdrawdisk1 = "/dev/sda"; # CHANGE THESE
  sshdrawdisk2 = "/dev/sdb"; # CHANGE THESE

#  ssdrawdisk1 = "/dev/vda"; # CHANGE THESE
#  ssdrawdisk2 = "/dev/vdb"; # CHANGE THESE
#  ssdrawdisk3 = "/dev/vda"; # CHANGE THESE
#  ssdrawdisk4 = "/dev/vdb"; # CHANGE THESE
in
{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/nvme0";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1M";
              end = "128M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Override existing partition
                mountpoint = "/";
                mountOptions = [ "noatime" ];
              };
            };
          };
        };
      };
      ${sshdrawdisk1} = {
        device = "${sshdrawdisk1}";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            sshd = {
              label = "sshd";
              name = "sshd";
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" "-m raid1 -d raid1" "${sshdrawdisk2}" ];
                mountpoint = "/opt/sshd";
                mountOptions = [ "noatime" ];
              };
            };
          };
        };
      };
#      ${ssdrawdisk1} = {
#        device = "${ssdrawdisk1}";
#        type = "disk";
#        content = {
#          type = "gpt";
#          partitions = {
#            sshd = {
#              label = "ssd";
#              name = "ssd";
#              size = "100%";
#              content = {
#                type = "btrfs";
#                extraArgs = [ "-f" "-m raid10 -d raid10" "${ssdrawdisk2}" "${ssdrawdisk3}" "${ssdrawdisk4}" ];
#                mountpoint = "/opt/ssd";
#                mountOptions = [ "noatime" ];
#              };
#            };
#          };
#        };
#      };
    };
  };
 };
}
