# xbrightness

Adjust screen brightness and colour temperature at your will, usefull to set keyboard shortcuts.

## Requirement

Your gnome session must be Xorg. To quicky check if you're unluckily running on Wayland, press alt+F2, then type 'r', then Enter. If it doesn't work, please switch to Xorg.

## Initialisation

In your home config directory `~/.config/xbrightness`:

* create a file named `brightness` with an arbitrary brightness level between 0 and 100
* create a file named `gamma_level` with an arbitrary gamma level between 0 and 19 (choose 8 for neutral temperature, see xbrightness.sh)

## Usage

`xbrightness [--help] [--warm | --cold] [--get] [--set | --increase | --decrease <int>]`

* `--help`, `-h`                  Print command usage
* `--warm`, `-w`                  Increase screen colour temperature (more warm/red)
* `--cold`, `-c`                  Decrease screen colour temperature (more cold/blue)
* `--get`, `-g`                   Print current screen bightness
* `--set <int>`, `-s <int>`       Set screen brightness to given level (for example, `xbrightness -s 50` sets screen brightness to 0.50)
* `--increase <int>`, `-i <int>`  Increase screen brightness by given level (for example, `xbrightness -i 5` sets screen brightness 0.05 brighter)
* `--decrease <int>`, `-d <int>`  Decrease screen brightness by given level (for example, `xbrightness -d 5` sets screen brightness 0.05 darker)

`xbrightness` call with no options resets screen brightness and colour temperature to previously saved levels.
