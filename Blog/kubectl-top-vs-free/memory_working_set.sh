#!/usr/bin/env bash

# This script reproduces what the kubelet does
# to calculate current working set of the node in bytes.
# node memory working set
anon_in_bytes=$(cat /sys/fs/cgroup/memory.stat | grep '^anon\b' | awk '{print $2}')
file_in_bytes=$(cat /sys/fs/cgroup/memory.stat | grep '^file\b' | awk '{print $2}')
memory_usage_in_bytes=$((anon_in_bytes + file_in_bytes))
memory_total_inactive_file=$(cat /sys/fs/cgroup/memory.stat | grep '^inactive_file\b' | awk '{print $2}')
memory_working_set=${memory_usage_in_bytes}
if [ "$memory_working_set" -lt "$memory_total_inactive_file" ]; then
    memory_working_set=0
else
    memory_working_set=$((memory_usage_in_bytes - memory_total_inactive_file))
fi
echo "memory.working_set_bytes $memory_working_set"
