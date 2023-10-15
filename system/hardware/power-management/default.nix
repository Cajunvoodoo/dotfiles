{ pkgs, ... }:

{
  services.tlp = {
    enable = true;
    settings = {
      # Performance Policy
      CPU_ENERGY_PERF_POLICY_ON_AC  = "balance_power";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      # CPU Performance Caps
      CPU_MIN_PERF_ON_AC  = 0;
      CPU_MIN_PERF_ON_BAT  = 0;

      CPU_MAX_PERF_ON_AC  = 100;
      CPU_MAX_PERF_ON_BAT  = 50;

      # Platform Profile
      PLATFORM_PROFILE_ON_AC  = "balanced";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      # Boost
      CPU_BOOST_ON_AC  = 1;
      CPU_BOOST_ON_BAT = 0;

      CPU_HWP_DYN_BOOST_ON_AC  = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;

      # Runtime Power Management
      RUNTIME_PM_ON_AC  = "auto";
      RUNTIME_PM_ON_BAT = "auto";

      # Wifi Power Save
      WIFI_PWR_ON_AC  = "on";
      WIFI_PWR_ON_BAT = "on";

      # Hybrid Graphics Management
      RUNTIME_PM_DRIVER_DENYLIST = "mei_me";

      # TODO: determine if these should be enabled
      MEM_SLEEP_ON_AC  = "s2idle";
      MEM_SLEEP_ON_BAT = "deep";

    };
  };
}
