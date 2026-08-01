# his.md

HIS (Hyprland Instance Signature) identifies a running Hyprland instance.

Env var `$HYPRLAND_INSTANCE_SIGNATURE`; sockets live under `$XDG_RUNTIME_DIR/hypr/[HIS]/`. `.socket.sock` handles hyprctl-like synchronous requests; `.socket2.sock` broadcasts events (`EVENT>>DATA`). Multi-instance selection via `hyprctl -i [instance]`; list with `hyprctl instances`.
