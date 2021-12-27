
# Create random board with single digit
# If counter matches a digit, delete the digit and redraw
# Advance numberline if needed
# If gap < 1 end game


counter_val=0
gap=0
numberline=0
cycle_time=1

setup() {
    counter_val=0
    gap=20
    game_continues=1
    max_val=9
    min_val=1
    numberline=$(( $RANDOM % $max_val + $min_val ))
    cycle_time=1
    SECONDS=0

}

remove_digit() {
    # pass in digit and number
    new_numberline=""
    digit=$1
    number=$2
    for ((i=0; i < ${#number}; i++ )) {
        numberline_digit="${numberline:$i:1}"
        if [[ $numberline_digit -ne $digit ]]; then
            new_numberline=$new_numberline$numberline_digit
        else
            ((gap+=1))
        fi
    }
    numberline=$new_numberline
}

delete_line() {
    # delete line and write string
    for ((i=0; i < 40; i++)) {
        echo -n -e "\b \b"
    }
}

write_scene() {
    # pass in counter value, gap size, and numberline
    delete_line
    echo -n -e $1
    g=$2
    for (( i=0; i < $g; i++ ))
    do
        echo -n -e " "
    done

    echo -n -e $3
}

main() {
    setup
    while  [[ $gap -gt 1 ]]
    do
        read -rsn1 -t 0.01 input
        if [ "$input" = "w" ]; then
            ((counter_val+=1))
            if [ "$counter_val" -gt 9 ]; then
                counter_val=0
            fi
            write_scene $counter_val $gap $numberline
        fi

        if [ "$input" = "s" ]; then
            remove_digit $counter_val $numberline
            write_scene $counter_val $gap $numberline
        fi
        
        if [[ "$gap" -lt 1 ]]; then
           game_continues=0
            echo "End"
         exit 0
        fi

        if [[ "$SECONDS" -gt $cycle_time ]]; then
            ((gap-=1))
            numberline=$numberline$(( $RANDOM % $max_val + $min_val ))
            SECONDS=0
            write_scene $counter_val $gap $numberline
        fi
    done
}

main
