{ ... }:

{
  services.thinkfan = {
    enable = true;
    sensors = [
      {
        # CPU Package Temperature (the most important)
        type = "hwmon";
        query = "/sys/devices/platform/coretemp.0/hwmon/hwmon5/temp1_input";
      }
      {
        # NVMe SSD Composite Temperature
        type = "hwmon";
        query = "/sys/class/hwmon/hwmon0/temp1_input";
      }
    ];
    levels = [
      # [LEVEL  MIN  MAX]

      # Fan is off up to 60°C.
      [
        0
        0
        60
      ]

      # Level 1 (quiet): Starts at 60°C, stops when cooling down below 55°C.
      [
        1
        55
        65
      ]

      # Level 3 (medium): Starts at 65°C, stops when cooling down below 60°C.
      [
        3
        60
        75
      ]

      # Level 7 (full speed): For heavy load, starts at 75°C.
      [
        7
        70
        32767
      ]
    ];
  };
}
