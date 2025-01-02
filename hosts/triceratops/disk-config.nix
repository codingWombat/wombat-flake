{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/vda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            MBR = {
              type = "EF02"; # for grub MBR
              size = "1M";
            };
            ESP = {
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
      sshdone = {
        type = "disk";
        device = "sshdone";
        content = {
          type = "gpt";
          mdadm = {
            size = "100%";
            content = {
              type = "mdraid";
              name = "raid1";
            };
          };
        };
      };
      sshdtwo = {
        type = "disk";
        device = "sshdtwo";
        content = {
          type = "gpt";
          mdadm = {
            size = "100%";
            content = {
              type = "mdraid";
              name = "raid1";
            };
          };
        };
      };
      ssdone = {
        type = "disk";
        device = "ssdone";
        content = {
          type = "gpt";
          mdadm = {
            size = "100%";
            content = {
              type = "mdraid";
              name = "raid2";
            };
          };
        };
      };
      ssdtwo = {
        type = "disk";
        device = "ssdtwo";
        content = {
          type = "gpt";
          mdadm = {
            size = "100%";
            content = {
              type = "mdraid";
              name = "raid2";
            };
          };
        };
      };
      ssdthree = {
        type = "disk";
        device = "ssdthree";
        content = {
          type = "gpt";
          mdadm = {
            size = "100%";
            content = {
              type = "mdraid";
              name = "raid2";
            };
          };
        };
      };
      ssdfour = {
        type = "disk";
        device = "ssdfour";
        content = {
          type = "gpt";
          mdadm = {
            size = "100%";
            content = {
              type = "mdraid";
              name = "raid2";
            };
          };
        };
      };
      mdadm = {
        raid1 = {
          type = "mdadm";
          level = 1;
          content = {
            type = "gpt";
            partitions.primary = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/pvc/sshd";
              };
            };
          };
        };
        raid2 = {
          type = "mdadm";
          level = 10;
          content = {
            type = "gpt";
            partitions.primary = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/pvc/ssd";
              };
            };
          };
        };
      };
    };
  };
}