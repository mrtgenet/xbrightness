#!/bin/bash
# Set, increase or decrease screen brightness 
# Change colour temperature (cold/warm)

# This script runs at start up (see ./config/autostart/xbrightness.sh.desktop)
# This script runs at wakeup (see /etc/systemd/system/xbrightness.service

#BRIGHTNESS=`xrandr --verbose | grep -m 1 -i brightness | cut -f2 -d ' '`

# TODO 
# Récupérer le résultat de `xrandr --verbose | grep -m 1 -i gamma` pour chaque niveau
# Créer liste GAMMA_INV
# Dans xbrightness() faire une inversion 

GAMMA[0]="0.77442176:0.85453121:1.00000000"
GAMMA[1]="0.78988728:0.86491137:1.00000000" # 10000K NighLight highest value (cold/blue)
GAMMA[2]="0.80753191:0.87667891:1.00000000"
GAMMA[3]="0.82782969:0.89011714:1.00000000"
GAMMA[4]="0.85139976:0.90559011:1.00000000"
GAMMA[5]="0.87906581:0.92357340:1.00000000"
GAMMA[6]="0.91194747:0.94470005:1.00000000"
GAMMA[7]="0.95160805:0.96983355:1.00000000"
GAMMA[8]="1.00000000:1.00000000:1.00000000" # 6500K default NightLight off temperature
GAMMA[9]="1.00000000:0.97107439:0.94305985"
GAMMA[10]="1.00000000:0.93853986:0.88130458"
GAMMA[11]="1.00000000:0.90198230:0.81465502"
GAMMA[12]="1.00000000:0.86860704:0.73688797"
GAMMA[13]="1.00000000:0.82854786:0.64816570"
GAMMA[14]="1.00000000:0.77987699:0.54642268"
GAMMA[15]="1.00000000:0.71976951:0.42860152"
GAMMA[16]="1.00000000:0.64373109:0.28819679"
GAMMA[17]="1.00000000:0.54360078:0.08679949"
GAMMA[18]="1.00000000:0.42322816:0.00000000"
GAMMA[19]="1.00000000:0.18172716:0.00000000" # 1000K NightLight lowest value (warm/red)

CUR_GAMMA_LEVEL=`cat ${HOME}/.config/xbrightness/gamma_level`
BRIGHTNESS=`cat ${HOME}/.config/xbrightness/brightness`

usage() { 
    echo "Usage: $0 [--help] [--warm | --cold] [--get] [--set | --increase | --decrease <int>]" 1>&2;
    exit 1;
}

clamp() {
    if (( $(echo "${BRIGHTNESS} > 1.0" | bc -l) ));
    then
        BRIGHTNESS=1.0
    fi
    if (( $(echo "${BRIGHTNESS} < 0.0" | bc -l) ));
    then
        BRIGHTNESS=0.0
    fi
    if [ ${CUR_GAMMA_LEVEL} -lt 0 ]
    then
        $CUR_GAMMA_LEVEL=0
    fi
    if [ ${CUR_GAMMA_LEVEL} -gt 19 ]
    then
        $CUR_GAMMA_LEVEL=19
    fi
}

set_brightness_gamma() {
    clamp
    echo ${CUR_GAMMA_LEVEL} > ${HOME}/.config/xbrightness/gamma_level
    echo ${BRIGHTNESS} > ${HOME}/.config/xbrightness/brightness
    xrandr --output eDP-1 --brightness ${BRIGHTNESS} --gamma ${GAMMA[${CUR_GAMMA_LEVEL}]};
    exit 0;
}

# Transform long options to short ones
for arg in "$@"; do
  shift
  case "$arg" in
    "--help")     set -- "$@" "-h" ;;
    "--warm")     set -- "$@" "-w" ;;
    "--cold")     set -- "$@" "-c" ;;
    "--get")      set -- "$@" "-g" ;;
    "--set")      set -- "$@" "-s" ;;
    "--increase") set -- "$@" "-i" ;;
    "--decrease") set -- "$@" "-d" ;;
    *)            set -- "$@" "$arg"
  esac
done

# Main
unset name
while getopts ":hwcgs:i:d:" o; do
    case "${o}" in
        h)
            usage
            ;;
        w)
            CUR_GAMMA_LEVEL=`expr ${CUR_GAMMA_LEVEL} + 1`
            set_brightness_gamma
            ;;
        c)
            CUR_GAMMA_LEVEL=`expr ${CUR_GAMMA_LEVEL} - 1`
            set_brightness_gamma
            ;;
        g)
            echo ${BRIGHTNESS}
            ;;
        s)
            BRIGHTNESS=`echo ${OPTARG} \* 0.01 | bc`
            set_brightness_gamma
            ;;
        i)
            ARG=`echo ${OPTARG} \* 0.01 | bc`
            BRIGHTNESS=`echo ${BRIGHTNESS} + ${ARG} | bc`
            set_brightness_gamma
            ;;
        d)
            ARG=`echo ${OPTARG} \* 0.01 | bc`
            BRIGHTNESS=`echo ${BRIGHTNESS} - ${ARG} | bc`
            set_brightness_gamma
            ;;
        *)
            usage
            ;;
    esac
done

if [ -z "$name" ]
then
   xrandr --output eDP-1 --brightness ${BRIGHTNESS} --gamma ${GAMMA[${CUR_GAMMA_LEVEL}]}
   exit 0
fi

