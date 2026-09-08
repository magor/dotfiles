{
  config,
  lib,
  pkgs,
  ...
}:

let
  # i5-1245U defaults to 2 P-cores; 6 threads was faster in local tests.
  numThreads = 6;
  baseModel = "qwen2.5-coder:7b";
  tunedModel = "qwen2.5-coder:7b-t${toString numThreads}";
  modelfile = pkgs.writeText "Modelfile-${tunedModel}" ''
    FROM ${baseModel}
    PARAMETER num_thread ${toString numThreads}
  '';
  ollamaBin = lib.getExe config.services.ollama.package;
  ollamaHost = "${config.services.ollama.host}:${toString config.services.ollama.port}";
in
{
  # Enable the Ollama service to handle local inference
  services.ollama = {
    enable = true;
    #acceleration = null; # Will fallback to CPU optimization for your Intel i5
    package = pkgs.ollama-cpu;
    environmentVariables = {
      OLLAMA_ORIGINS = "*";
    };
  };

  # OLLAMA_NUM_THREADS is ignored on 0.30.x; bake num_thread into a derived model.
  systemd.services.ollama-tuned-models = {
    description = "Create Ollama models with CPU thread overrides";
    wantedBy = [ "multi-user.target" ];
    after = [ "ollama.service" ];
    wants = [ "ollama.service" ];
    bindsTo = [ "ollama.service" ];
    # HOME is required (CLI panics without it); drop PATH so `path` can set it.
    environment = removeAttrs config.systemd.services.ollama.environment [ "PATH" ];
    path = [
      config.services.ollama.package
      pkgs.curl
      pkgs.coreutils
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      set -euo pipefail
      for _ in $(seq 1 60); do
        if curl -sf "http://${ollamaHost}/api/tags" >/dev/null; then
          break
        fi
        sleep 1
      done
      ${ollamaBin} show ${lib.escapeShellArg baseModel} >/dev/null
      ${ollamaBin} create ${lib.escapeShellArg tunedModel} -f ${modelfile}
    '';
  };
}
