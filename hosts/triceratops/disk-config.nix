let
#  sshdrawdisk1 = "/dev/sda"; # CHANGE THESE
#  sshdrawdisk2 = "/dev/sdb"; # CHANGE THESE

  ssdrawdisk1 = "/dev/sda"; # CHANGE THESE
  ssdrawdisk2 = "/dev/sdb"; # CHANGE THESE
  ssdrawdisk3 = "/dev/sdc"; # CHANGE THESE
  ssdrawdisk4 = "/dev/sdd"; # CHANGE THESE
in
{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/nvme0n1";
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
      data = {
        device = "${ssdrawdisk1}";
        type = "disk";
        name = "data";
        content = {
          type = "btrfs";
          extraArgs = [ "-f" "-m raid10 -d raid10" "${ssdrawdisk1}" "${ssdrawdisk2}" "${ssdrawdisk3}" "${ssdrawdisk4}" ];
          mountpoint = "/opt/data";
          mountOptions = [ "noatime" ];
        };
      };
    };
  };
}
