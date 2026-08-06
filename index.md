# knowledge-base

Yusheng's personal knowledge base.

## Format

### Install prettier [^1]

```bash
npm install --global prettier
```

### Pre-commit Hook [^2]

`.git/hooks/pre-commit`

```sh
#!/bin/sh
FILES=$(git diff --cached --name-only --diff-filter=ACMR | sed 's| |\\ |g')
[ -z "$FILES" ] && exit 0

# Prettify all selected files
echo "$FILES" | xargs prettier --ignore-unknown --write

# Add back the modified/prettified files to staging
echo "$FILES" | xargs git add

exit 0
```

Give it execute permission:

```bash
chmox +x .git/hooks/pre-commit
```

`.git/hooks/post-commit`

```sh
#!/bin/sh
git update-index -g
```

Give it execute permission:

```bash
chmox +x .git/hooks/post-commit
```

Ref:

[^1]: https://prettier.io/docs/install

[^2]: https://prettier.io/docs/precommit#option-5-shell-script
