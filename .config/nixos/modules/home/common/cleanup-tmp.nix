# Automatic age-based cleanup of ~/tmp via systemd-tmpfiles (user instance).
#
# Why this approach
# -----------------
# systemd-tmpfiles is the NixOS/systemd-native way to manage temporary paths by
# age, without writing a custom find script or a oneshot timer. Home Manager
# exposes the same mechanism for the *user* systemd instance, so cleanup runs
# in your session context and targets %h (your home directory).
#
# How create vs clean are scheduled
# ---------------------------------
# Writing a rule here only declares the path policy. Two separate user units
# apply it:
#
#   systemd-tmpfiles-setup.service  → systemd-tmpfiles --user --create
#     Creates ~/tmp (and applies mode) if missing. Typically runs at login /
#     Home Manager activation.
#
#   systemd-tmpfiles-clean.timer    → systemd-tmpfiles --user --clean
#     Periodically deletes contents older than Age. You do not need a custom
#     oneshot timer for this module.
#
# Quick Operations Reference
# --------------------------
# 1. Confirm the rule was installed after a Home Manager / NixOS switch:
#      ls ~/.config/user-tmpfiles.d/
#
# 2. Create the directory now (if missing) and dry-run / apply age cleanup:
#      systemd-tmpfiles --user --create
#      systemd-tmpfiles --user --clean --dry-run
#      systemd-tmpfiles --user --clean
#
# 3. See when the clean timer last ran / will run next:
#      systemctl --user list-timers | grep tmpfiles-clean
#
# 4. Inspect journal output from a clean run:
#      journalctl --user -u systemd-tmpfiles-clean.service -e
#
# Semantics of the rule below
# ---------------------------
# Format:  Type Path Mode User Group Age Argument
#
#   Type  "d"  = Ensure Path is a directory: create it if missing, then on
#                --clean runs remove *contents* older than Age. The directory
#                itself is never deleted. (Type "e" is similar but never
#                creates the path.)
#
#   Path  %h/tmp
#         %h expands to the invoking user's home directory (/home/mirek here).
#
#   Mode  "0755"
#         Applied when the directory is created (owner rwx, group/other rx).
#         Matches the usual umask-022 default for home subdirectories. Existing
#         directories are not forcibly re-chmod'd by default on every run unless
#         other tmpfiles options are used.
#
#   User / Group
#         "-" means "the user running systemd --user" / leave default. For a
#         user tmpfiles rule this is your own UID/GID, which is what we want.
#
#   Age   "mM:1w" = mtime only, one week (systemd 260+ syntax).
#         Format is "<age-by>:<age>", *not* "<age>:<age-by>".
#         - "mM" overrides the default age-by set (abcmABM). By default
#           tmpfiles keeps an entry if *any* of atime/btime/ctime/mtime is
#           recent — so merely listing files refreshes atime and blocks
#           cleanup. "m" = file mtime, "M" = directory mtime.
#         - "1w" is the threshold (one week).
#         - No leading "~" on the age-by field, so cleanup considers
#           immediate children of ~/tmp. An old top-level directory is
#           removed as a whole (contents go with it). Use "~mM:1w" for
#           recursive cleanup that also ages nested files under newer dirs.
#
#   Argument
#         Unused for type "d"; omitted (trailing field left empty).
#
# Caveats
# -------
# - With "mM", atime/ctime/btime are ignored; browsing ~/tmp will not
#   protect old files from deletion.
# - ~/tmp itself is never deleted — only its contents past Age.
# - This does not affect /tmp or /var/tmp; only ~/tmp.

{
  systemd.user.tmpfiles.rules = [
    "d %h/tmp 0755 - - mM:1w"
  ];
}
