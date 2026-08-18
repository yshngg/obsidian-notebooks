> A syntax-highlighting pager for git, diff, grep, rg --json, and blame output

```bash
git config --global core.pager delta
git config --global interactive.diffFilter 'delta --color-only'
git config --global delta.navigate true
# git config --global delta.dark true  # or `delta.light true`, or omit for auto-detection
git config --global merge.conflictStyle zdiff3
```

https://dandavison.github.io/delta/
https://github.com/dandavison/delta
