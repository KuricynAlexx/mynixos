{ config, lib, pkgs, ... }: {

  # --- AUDIO --- # 
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # Use the WirePlumber session manager
    #wireplumber.enable = true;

    # Swap the channels globally by forcing a re-map inside loopback
    # maybe because of bad headphones, I dont know
    # If it needs to swap left-right channels
   #extraConfig.pipewire."99-swap-channels" = {
   #  "context.modules" = [
   #    {
   #      name = "libpipewire-module-loopback";
   #      args = {
   #        "audio.position" = [ "FL" "FR" ];
   #        "capture.props" = {
   #          "media.class" = "Audio/Sink";
   #          "node.name" = "swapped_stereo";
   #          "node.description" = "Swapped Stereo Output";
   #        };
   #        "playback.props" = {
   #          "audio.position" = [ "FR" "FL" ]; # <--- Reverses the map here
   #          "node.target" = "my-default-sink"; # Paths directly to your hardware
   #        };
   #      };
   #    }
   #  ];
   #};
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # --- OTHERS --- #
  # Enable CUPS to print documents.
  services.printing.enable = true;
}
