## cgroup v1

max( memory.usage_in_bytes, memory.usage_in_bytes - memory.stat(total_inactive_file) )

## cgroup v2

max(memory.current, memory.current - memory.stat(inactive_file) )
