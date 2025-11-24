{ ... }:

{
  services = {
    netdata = {
      enable = true;
      config = {
        global = {
          # uncomment to reduce memory to 32 MB
          #"page cache size" = 32;

          # update interval
          "update every" = 15;
        };
        ml = {
          # enable machine learning
          "enabled" = "yes";
        };
      };
    };
  };
}
