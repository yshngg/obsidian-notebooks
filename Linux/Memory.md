[How does the OOM killer decide which process to kill first?](https://unix.stackexchange.com/questions/153585/how-does-the-oom-killer-decide-which-process-to-kill-first)

[How is kernel oom score calculated?](https://serverfault.com/questions/571319/how-is-kernel-oom-score-calculated)

[/proc/sys/vm/drop_caches](https://docs.kernel.org/admin-guide/sysctl/vm.html#drop-caches)

```
echo 1 > /proc/sys/vm/drop_caches
echo 2 > /proc/sys/vm/drop_caches
echo 3 > /proc/sys/vm/drop_caches
```

[Introduction to Memory Management in Linux](https://www.youtube.com/watch?v=7aONIVSXiJ8)

[Linux ate my ram!](https://www.linuxatemyram.com/)
[Experiments and fun with the Linux disk cache](https://www.linuxatemyram.com/play.html)

source code of free command
https://gitlab.com/procps-ng/procps/-/blob/master/src/free.c

source code of oom killer
https://github.com/torvalds/linux/blob/v7.1/mm/oom_kill.c#L1103

source code of `try_charge`
https://github.com/torvalds/linux/blob/v7.1/mm/memcontrol.c#L2766
