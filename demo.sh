#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/"

shopt -s expand_aliases
alias tomono="$(pwd)/tomono"

run_command() {
    local cmd="$1"
    echo "\$ $cmd"
    eval "$cmd"
}

export TMP_ROOT_PATH="$(mktemp -d)"
cd $TMP_ROOT_PATH

cat <<'EOF'
# POC to sync git monorepo with multirepos

More information on this project (in French): https://notes.sklein.xyz/Projet%2019/

## Walkthrough Demo

This demo is based on [`tomono`](https://github.com/hraban/tomono) script.

### Create frontend repository

Let's start by creating a frontend repository:
EOF

echo -e "\n\`\`\`sh"
run_command "mkdir frontend"
run_command "cd frontend"
run_command "git init"
echo ""
echo '$ echo "Frontend README" > README.md'
echo "Frontend README" > README.md

run_command "git add README.md"
run_command "git commit -m \"First frontend import\""

echo ""
echo '$ echo "Frontend feature a" > feature-a.txt'
echo "Frontend feature a" > feature-a.txt

run_command "git add feature-a.txt"
run_command "git commit -m \"Add Frontend feature-a.txt\""
echo ""

run_command "git switch -c feature-b"
echo '$ echo "Frontend Feature b" > feature-b.txt'
echo "Frontend Feature b" > feature-b.txt

run_command "git add feature-b.txt"
run_command "git commit -m \"Add Frontend feature-b.txt\""

echo ""

run_command "git log"

run_command "git switch main"
run_command "cd .."
echo -e "\`\`\`\n"

cat <<'EOF'

### Create backend repository

Next, let's create a backend repository:

EOF

echo -e "\n\`\`\`sh"
run_command "mkdir backend"
run_command "cd backend"
run_command "git init"
echo '$ echo "Backend README" > README.md'
echo "Backend README" > README.md
run_command "git add README.md"
run_command "git commit -m \"First backend import\""

echo '$ echo "Backend Feature c" > feature-c.txt'
echo "Backend Feature c" > feature-c.txt

run_command "git add feature-c.txt"
run_command "git commit -m \"Add Backend feature-a.txt\""

run_command "git switch -c feature-d"
echo '$ echo "Backend Feature d" > feature-d.txt'
echo "Backend Feature d" > feature-d.txt

run_command "git add feature-d.txt"
run_command "git commit -m \"Add backend feature-d.txt\""

run_command "git log"

run_command "git switch main"
run_command "cd .."
echo -e "\`\`\`\n"

cat <<'EOF'

### Create mono repository

Now let's check the folders and files that have been created:

EOF

echo -e "\n\`\`\`sh"
run_command "tree ."
echo -e "\`\`\`\n"

echo "Let's move on to the part we're interested in: creating a single repository:"

echo -e "\n\`\`\`sh"
cat <<'END'
export MONOREPO_NAME=monorepo

tomono <<EOF
$PWD/frontend frontend
$PWD/backend backend
EOF
END

export MONOREPO_NAME=monorepo

tomono <<EOF
$PWD/frontend frontend
$PWD/backend backend
EOF
echo -e "\`\`\`\n"

echo "Let's check the contents of the monorepo"

echo -e "\n\`\`\`sh"
run_command "cd monorepo"
run_command "tree ."
run_command "git log"
run_command "git remote -v"

cat <<'EOF'
```

Let's add some files to the root of the mono repo:

```sh
EOF

echo '$ echo "Monorepo" > README.md'
echo "Monorepo" > README.md

run_command "git add README.md"

echo '$ echo -e '[tools]\nnode = "20.12.2"' > .mise.toml'
echo -e '[tools]\nnode = "20.12.2"' > .mise.toml

run_command "git add .mise.toml"

run_command "git commit -m \"Root monorepo files\""

cat <<'EOF'
```

### Add commit to frontend

Now, let's make some changes to the frontend repository:

```sh
EOF

run_command "cd ../frontend"

echo '$ echo "Frontend Feature e" > feature-e.txt'
echo "Frontend Feature e" > feature-e.txt

run_command "git add feature-e.txt"
run_command "git commit -m \"Add Frontend feature-e.txt\""

run_command "git log"

cat <<'EOF'
```

Pull `frontend` last commit to `monorepo`:

```sh
EOF

run_command "cd ../monorepo"
run_command "git fetch frontend"
run_command "git merge -X subtree=frontend/ frontend/main --no-edit"

cat <<'EOF'
```

This is what the last log lines look like:

```sh
EOF

run_command "git log -n3"

cat <<'EOF'
```

## Making changes in the `./frontend/` folder of the *monorepo*

Now I want to make changes directly in the `./frontend/` folder of the *monorepo*.

I'm using a method based on *git patch* because I don't want to take the risk of pushing
changes directly to the multirepository, which remains the source of truth.  
I don't want to risk disrupting the work of my colleagues.

```sh
EOF

run_command "cd frontend"
echo '$ echo "Frontend Feature f" > feature-f.txt'
echo "Frontend Feature f" > feature-f.txt

run_command "git add feature-f.txt"
run_command "git commit -m \"Add Frontend feature-f.txt\""

run_command "git log -n3"

run_command "git format-patch --relative -1 HEAD"

run_command "cat 0001-Add-Frontend-feature-f.txt.patch"

cat <<'EOF'
```

Now I'm going to apply this patch in the `frontend` repository upstream.

```sh
EOF

run_command "cd ../../frontend/"

run_command "git am ../monorepo/frontend/0001-Add-Frontend-feature-f.txt.patch"

run_command "git log -n3"

cat <<'EOF'
```

## End of demo

You can visit https://github.com/stephane-klein/poc-git-monorepo-multirepos-sync-result-example to see what monorepo looks like at the end of this demo.

## Contribute

This `README.md` file is automatically generated by the `generate-readme.sh` script,
which executes the `demo.sh` script and saves the output in `README.md`.

EOF

#echo "$TMP_ROOT_PATH"
rm -rf $TMP_ROOT_PATH

