{ pkgs, ... }:

{
  # Enable the Ollama service to handle local inference
  services.ollama = {
    enable = true;
    #acceleration = null; # Will fallback to CPU optimization for your Intel i5
    package = pkgs.ollama-cpu;
  };
}
