#!/bin/sh

screen_timeout_default=300
screen_timeout_locked=3

revert() {
  xset dpms $screen_timeout_default $screen_timeout_default $screen_timeout_default
}
trap revert HUP INT TERM
xset +dpms dpms $screen_timeout_locked $screen_timeout_locked $screen_timeout_locked
i3lock -n -c 061218 -f
revert

