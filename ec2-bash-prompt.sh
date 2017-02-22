# Basic color codes
COLOR_WHITE='\e[1;37m'
COLOR_BLACK='\e[0;30m'
COLOR_BLUE='\e[0;34m'
COLOR_LIGHT_BLUE='\e[1;34m'
COLOR_GREEN='\e[0;32m'
COLOR_LIGHT_GREEN='\e[1;32m'
COLOR_CYAN='\e[0;36m'
COLOR_LIGHT_CYAN='\e[1;36m'
COLOR_RED='\e[0;31m'
COLOR_LIGHT_RED='\e[1;31m'
COLOR_PURPLE='\e[0;35m'
COLOR_LIGHT_PURPLE='\e[1;35m'
COLOR_BROWN='\e[0;33m'
COLOR_YELLOW='\e[1;33m'
COLOR_GRAY='\e[0;30m'
COLOR_LIGHT_GRAY='\e[0;37m'
BOLD='\e[1m'
FAINT='\e[2m'
ITLCS='\e[3m'
BG='\e[48;5;236m' # Dark Gray Background

# These are used to make a gradiant effect
GRAY232='\e[48;5;232m'
GRAY233='\e[48;5;233m'
GRAY234='\e[48;5;234m'
GRAY235='\e[48;5;235m'
GRAY236='\e[48;5;236m'

# Gradiant to fade to black
GRAD="${GRAY236} ${GRAY235} ${GRAY234} ${GRAY233} ${GRAY232} "

# End color effects
OFF='\e[0m'

# If we are in an interactive shell, do the following...
if [ "${-#*i}" != "$-" ]; then

    # Get some data we'd like to use in our prompt
    EC2_NAME=$(get-tag | sed 's/ /-/g' | sed 's/"//g')
    EC2_ID=$(curl -s --fail http://169.254.169.254/latest/meta-data/instance-id)
    EC2_AZ=$(curl -s --fail http://169.254.169.254/latest/meta-data/placement/availability-zone)

    case $TERM in
        xterm*)
            PS1="${BOLD}${COLOR_CYAN}${BG}${EC2_NAME}${OFF}${BOLD}${BG} ${COLOR_BLUE}${BG}${EC2_ID}${OFF}${BOLD}${BG} ${COLOR_RED}${BG}${EC2_AZ}${OFF}${BOLD}${GRAD}${OFF}\n\u@\h \w \\$ "
            ;;
        *)
            PS1="[$EC2_NAME] [$EC2_ID] [$EC2_AZ]\n\u@\h \w \\$ "
            ;;
    esac

    export PS1
fi

