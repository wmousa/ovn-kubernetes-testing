iperf_client_exec(){
    local pod="$1"
    local ip="$2"
    local port="$3"

    exec_command=${4:-"kubectl  exec -it $pod --"}

    local iperf_flags=" -c $ip -t 5 --json --connect-timeout 10000"

    if [[ -n "$port" ]]
    then
        iperf_flags+=" -p $port"
    fi

    get_bit_rate "kubectl  exec -it $pod -- iperf3  $iperf_flags"
}

netns_client_exec(){
    local ip="$1"
    local port="$2"

    local iperf_flags=" -c $ip -t 5 --json --connect-timeout 10000"

    if [[ -n "$port" ]]
    then
        iperf_flags+=" -p $port"
    fi

    get_bit_rate "ip netns exec $gw_netns iperf3 $iperf_flags"
}

get_bit_rate(){
    local exec_comamnd=$1
    bit_rate=$(${exec_comamnd} | jq -e .end.sum_received.bits_per_second)

    if [[ "$?" != "0" ]]
    then
        echo "Connection Timeout"
    else
            if [[ $bit_rate == "0" ]]
            then
                bit_rate=$(${exec_comamnd} | jq -e .end.sum_received.bits_per_second)
            fi
            echo bit_rate = $((${bit_rate%.*}/1000000000)) GB $((${bit_rate%.*}/1000000)) MB
    fi
    echo ""
    echo "-----------------------------------------------------------------------------------------------------------------------------"

}
