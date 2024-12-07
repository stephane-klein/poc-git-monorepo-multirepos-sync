# POC to sync git monorepo with multirepos

More information on this project (in French): https://notes.sklein.xyz/Projet%2019/

## Walkthrough Demo

This demo is based on [`tomono`](https://github.com/hraban/tomono) script.

### Create frontend repository

Let's start by creating a frontend repository:

```sh
$ mkdir frontend
$ cd frontend
$ git init
Dépôt Git vide initialisé dans /tmp/tmp.aOzaWeLmKk/frontend/.git/

$ echo "Frontend README" > README.md
$ git add README.md
$ git commit -m "First frontend import"
[main (commit racine) 40a64bb] First frontend import
 1 file changed, 1 insertion(+)
 create mode 100644 README.md

$ echo "Frontend feature a" > feature-a.txt
$ git add feature-a.txt
$ git commit -m "Add Frontend feature-a.txt"
[main 61a7b52] Add Frontend feature-a.txt
 1 file changed, 1 insertion(+)
 create mode 100644 feature-a.txt

$ git switch -c feature-b
Basculement sur la nouvelle branche 'feature-b'
$ echo "Frontend Feature b" > feature-b.txt
$ git add feature-b.txt
$ git commit -m "Add Frontend feature-b.txt"
[feature-b 97d082f] Add Frontend feature-b.txt
 1 file changed, 1 insertion(+)
 create mode 100644 feature-b.txt

$ git log
commit 97d082fd95461d1ad56398ba9084764009415738
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:46:18 2024 +0100

    Add Frontend feature-b.txt

commit 61a7b52b0fa86408f8f8e85a5fafcf829eabe334
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:46:18 2024 +0100

    Add Frontend feature-a.txt

commit 40a64bb04659f9ada47b77e6bbe194e7dd68ecd4
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:46:18 2024 +0100

    First frontend import
$ git switch main
Basculement sur la branche 'main'
$ cd ..
```


### Create backend repository

Next, let's create a backend repository:


```sh
$ mkdir backend
$ cd backend
$ git init
Dépôt Git vide initialisé dans /tmp/tmp.aOzaWeLmKk/backend/.git/
$ echo "Backend README" > README.md
$ git add README.md
$ git commit -m "First backend import"
[main (commit racine) f55b62f] First backend import
 1 file changed, 1 insertion(+)
 create mode 100644 README.md
$ echo "Backend Feature c" > feature-c.txt
$ git add feature-c.txt
$ git commit -m "Add Backend feature-a.txt"
[main baac6be] Add Backend feature-a.txt
 1 file changed, 1 insertion(+)
 create mode 100644 feature-c.txt
$ git switch -c feature-d
Basculement sur la nouvelle branche 'feature-d'
$ echo "Backend Feature d" > feature-d.txt
$ git add feature-d.txt
$ git commit -m "Add backend feature-d.txt"
[feature-d 9c3aad5] Add backend feature-d.txt
 1 file changed, 1 insertion(+)
 create mode 100644 feature-d.txt
$ git log
commit 9c3aad5bcd333dc80d45122665f532dab56c0600
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:46:18 2024 +0100

    Add backend feature-d.txt

commit baac6bebe4a668b641395851c050868dce55e936
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:46:18 2024 +0100

    Add Backend feature-a.txt

commit f55b62fc2c2dabc78302cb9d335311cb10fca685
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:46:18 2024 +0100

    First backend import
$ git switch main
Basculement sur la branche 'main'
$ cd ..
```


### Create mono repository

Now let's check the folders and files that have been created:


```sh
$ tree .
.
├── backend
│   ├── feature-c.txt
│   └── README.md
└── frontend
    ├── feature-a.txt
    └── README.md

3 directories, 4 files
```

Let's move on to the part we're interested in: creating a single repository:

```sh
export MONOREPO_NAME=monorepo

tomono <<EOF
$PWD/frontend frontend
$PWD/backend backend
EOF
Dépôt Git vide initialisé dans /tmp/tmp.aOzaWeLmKk/monorepo/.git/
Depuis /tmp/tmp.aOzaWeLmKk/frontend
 * [nouvelle branche] feature-b  -> frontend/feature-b
 * [nouvelle branche] main       -> frontend/main
Depuis /tmp/tmp.aOzaWeLmKk/backend
 * [nouvelle branche] feature-d  -> backend/feature-d
 * [nouvelle branche] main       -> backend/main
4 chemins mis à jour depuis l'index
```

Let's check the contents of the monorepo

```sh
$ cd monorepo
$ tree .
.
├── backend
│   ├── feature-c.txt
│   └── README.md
└── frontend
    ├── feature-a.txt
    └── README.md

3 directories, 4 files
$ git log
commit a9c570256287fc4734b9fbc2ee567e3c6b4e804e
Merge: 37443bd ea73ada
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:46:18 2024 +0100

    Merge backend/main

commit 37443bd7b430f280072abe8cf310e36d780d78ae
Merge: aaa1b6b d186ca4
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:46:18 2024 +0100

    Merge frontend/main

commit ea73adab10636fb5de62fd7fd6e5343ceee1577d
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:46:18 2024 +0100

    Move all files to backend/

commit aaa1b6b031d95e53ccbad7576aed59d0279a2bbb
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:46:18 2024 +0100

    Root commit for monorepo branch main

commit d186ca4250be1aecbc9df84efea8760a2d9a80cb
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:46:18 2024 +0100

    Move all files to frontend/

commit baac6bebe4a668b641395851c050868dce55e936
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:46:18 2024 +0100

    Add Backend feature-a.txt

commit 61a7b52b0fa86408f8f8e85a5fafcf829eabe334
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:46:18 2024 +0100

    Add Frontend feature-a.txt

commit f55b62fc2c2dabc78302cb9d335311cb10fca685
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:46:18 2024 +0100

    First backend import

commit 40a64bb04659f9ada47b77e6bbe194e7dd68ecd4
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:46:18 2024 +0100

    First frontend import
$ git remote -v
backend	/tmp/tmp.aOzaWeLmKk/backend (fetch)
backend	/tmp/tmp.aOzaWeLmKk/backend (push)
frontend	/tmp/tmp.aOzaWeLmKk/frontend (fetch)
frontend	/tmp/tmp.aOzaWeLmKk/frontend (push)
```

Let's add some files to the root of the mono repo:

```sh
$ echo "Monorepo" > README.md
$ git add README.md
$ echo -e [tools]nnode = 20.12.2 > .mise.toml
$ git add .mise.toml
$ git commit -m "Root monorepo files"
[main 0e9cf40] Root monorepo files
 2 files changed, 3 insertions(+)
 create mode 100644 .mise.toml
 create mode 100644 README.md
```

### Add commit to frontend

Now, let's make some changes to the frontend repository:

```sh
$ cd ../frontend
$ echo "Frontend Feature e" > feature-e.txt
$ git add feature-e.txt
$ git commit -m "Add Frontend feature-e.txt"
[main 05dd399] Add Frontend feature-e.txt
 1 file changed, 1 insertion(+)
 create mode 100644 feature-e.txt
$ git log
commit 05dd39973564484dd321396b711aa864482673ed
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:46:18 2024 +0100

    Add Frontend feature-e.txt

commit 61a7b52b0fa86408f8f8e85a5fafcf829eabe334
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:46:18 2024 +0100

    Add Frontend feature-a.txt

commit 40a64bb04659f9ada47b77e6bbe194e7dd68ecd4
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:46:18 2024 +0100

    First frontend import
```

Pull `frontend` last commit to `monorepo`:

```sh
$ cd ../monorepo
$ git fetch frontend
Depuis /tmp/tmp.aOzaWeLmKk/frontend
   61a7b52..05dd399  main       -> frontend/main
$ git merge -X subtree=frontend/ frontend/main --no-edit
Merge made by the 'ort' strategy.
 frontend/feature-e.txt | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 frontend/feature-e.txt
```

This is what the last log lines look like:

```sh
$ git log -n3
commit f911bdb130a95fe52312b84c478d007bf331d63a
Merge: 0e9cf40 05dd399
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:46:18 2024 +0100

    Merge remote-tracking branch 'frontend/main'

commit 0e9cf406cc21fd7fc78c3b454757e25e04d49147
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:46:18 2024 +0100

    Root monorepo files

commit 05dd39973564484dd321396b711aa864482673ed
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:46:18 2024 +0100

    Add Frontend feature-e.txt
```

## Making changes in the `./frontend/` folder of the *monorepo*

Now I want to make changes directly in the `./frontend/` folder of the *monorepo*.

I'm using a method based on *git patch* because I don't want to take the risk of pushing
changes directly to the multirepository, which remains the source of truth.  
I don't want to risk disrupting the work of my colleagues.

```sh
$ cd frontend
$ echo "Frontend Feature f" > feature-f.txt
$ git add feature-f.txt
$ git commit -m "Add Frontend feature-f.txt"
[main 2b9c8c3] Add Frontend feature-f.txt
 1 file changed, 1 insertion(+)
 create mode 100644 frontend/feature-f.txt
$ git log -n3
commit 2b9c8c347613c30a63cf03d6623d7cbd82794f37
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:46:18 2024 +0100

    Add Frontend feature-f.txt

commit f911bdb130a95fe52312b84c478d007bf331d63a
Merge: 0e9cf40 05dd399
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:46:18 2024 +0100

    Merge remote-tracking branch 'frontend/main'

commit 0e9cf406cc21fd7fc78c3b454757e25e04d49147
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:46:18 2024 +0100

    Root monorepo files
$ git format-patch --relative -1 HEAD
0001-Add-Frontend-feature-f.txt.patch
$ cat 0001-Add-Frontend-feature-f.txt.patch
From 2b9c8c347613c30a63cf03d6623d7cbd82794f37 Mon Sep 17 00:00:00 2001
From: stephane-klein <contact@stephane-klein.info>
Date: Sat, 7 Dec 2024 20:46:18 +0100
Subject: [PATCH] Add Frontend feature-f.txt

---
 feature-f.txt | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 frontend/feature-f.txt

diff --git a/feature-f.txt b/feature-f.txt
new file mode 100644
index 0000000..fd77637
--- /dev/null
+++ b/feature-f.txt
@@ -0,0 +1 @@
+Frontend Feature f
-- 
2.47.1

```

Now I'm going to apply this patch in the `frontend` repository upstream.

```sh
$ cd ../../frontend/
$ git am ../monorepo/frontend/0001-Add-Frontend-feature-f.txt.patch
Application de  Add Frontend feature-f.txt
$ git log -n3
commit b860de788f1c2ae056778f9c3048900d0887afaa
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:46:18 2024 +0100

    Add Frontend feature-f.txt

commit 05dd39973564484dd321396b711aa864482673ed
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:46:18 2024 +0100

    Add Frontend feature-e.txt

commit 61a7b52b0fa86408f8f8e85a5fafcf829eabe334
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:46:18 2024 +0100

    Add Frontend feature-a.txt
```

## End of demo

You can visit https://github.com/stephane-klein/poc-git-monorepo-multirepos-sync-result-example to see what monorepo looks like at the end of this demo.

## Contribute

This `README.md` file is automatically generated by the `generate-readme.sh` script,
which executes the `demo.sh` script and saves the output in `README.md`.

