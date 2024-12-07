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
Dépôt Git vide initialisé dans /tmp/tmp.nxfPqzVht3/frontend/.git/

$ echo "Frontend README" > README.md
$ git add README.md
$ git commit -m "First frontend import"
[main (commit racine) c3adb23] First frontend import
 1 file changed, 1 insertion(+)
 create mode 100644 README.md

$ echo "Frontend feature a" > feature-a.txt
$ git add feature-a.txt
$ git commit -m "Add Frontend feature-a.txt"
[main dff7720] Add Frontend feature-a.txt
 1 file changed, 1 insertion(+)
 create mode 100644 feature-a.txt

$ git switch -c feature-b
Basculement sur la nouvelle branche 'feature-b'
$ echo "Frontend Feature b" > feature-b.txt
$ git add feature-b.txt
$ git commit -m "Add Frontend feature-b.txt"
[feature-b 518ed3c] Add Frontend feature-b.txt
 1 file changed, 1 insertion(+)
 create mode 100644 feature-b.txt

$ git log
commit 518ed3c7c53b37b9f1e9974b2c7dcf0b4a201f5c
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    Add Frontend feature-b.txt

commit dff7720846eb89a87ee7e154bbe58658eb685547
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    Add Frontend feature-a.txt

commit c3adb23c07773201d56b66feb44ddb1dcd2f7573
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

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
Dépôt Git vide initialisé dans /tmp/tmp.nxfPqzVht3/backend/.git/
$ echo "Backend README" > README.md
$ git add README.md
$ git commit -m "First backend import"
[main (commit racine) 9cf591f] First backend import
 1 file changed, 1 insertion(+)
 create mode 100644 README.md
$ echo "Backend Feature c" > feature-c.txt
$ git add feature-c.txt
$ git commit -m "Add Backend feature-a.txt"
[main 1bd616c] Add Backend feature-a.txt
 1 file changed, 1 insertion(+)
 create mode 100644 feature-c.txt
$ git switch -c feature-d
Basculement sur la nouvelle branche 'feature-d'
$ echo "Backend Feature d" > feature-d.txt
$ git add feature-d.txt
$ git commit -m "Add backend feature-d.txt"
[feature-d d586865] Add backend feature-d.txt
 1 file changed, 1 insertion(+)
 create mode 100644 feature-d.txt
$ git log
commit d586865a5037e83ef2b5e69cc0d6ed02994a909b
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    Add backend feature-d.txt

commit 1bd616cc93a686fedcdc327eaa077f3426f02970
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    Add Backend feature-a.txt

commit 9cf591f583204e1d2055ee6794e0e32ae0226c74
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

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
Dépôt Git vide initialisé dans /tmp/tmp.nxfPqzVht3/monorepo/.git/
Depuis /tmp/tmp.nxfPqzVht3/frontend
 * [nouvelle branche] feature-b  -> frontend/feature-b
 * [nouvelle branche] main       -> frontend/main
Depuis /tmp/tmp.nxfPqzVht3/backend
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
commit fd1d878d1bf47a613a779b97cf6810f19a4ded1c
Merge: cb61337 0c7a286
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    Merge backend/main

commit cb61337fc515d08683961e9fe75fbeebf057db7e
Merge: 8707d00 1e4a508
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    Merge frontend/main

commit 0c7a286bfef0ffc9ad292dc4bafb377cac59bb0e
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    Move all files to backend/

commit 8707d00c0702d915f21670b8d7be67d78f978aa9
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    Root commit for monorepo branch main

commit 1e4a508e4d84ddfdc69afcda36418fdd2bd95ede
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    Move all files to frontend/

commit 1bd616cc93a686fedcdc327eaa077f3426f02970
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    Add Backend feature-a.txt

commit dff7720846eb89a87ee7e154bbe58658eb685547
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    Add Frontend feature-a.txt

commit 9cf591f583204e1d2055ee6794e0e32ae0226c74
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    First backend import

commit c3adb23c07773201d56b66feb44ddb1dcd2f7573
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    First frontend import
$ git remote -v
backend	/tmp/tmp.nxfPqzVht3/backend (fetch)
backend	/tmp/tmp.nxfPqzVht3/backend (push)
frontend	/tmp/tmp.nxfPqzVht3/frontend (fetch)
frontend	/tmp/tmp.nxfPqzVht3/frontend (push)
```

Let's add some files to the root of the mono repo:

```sh
$ echo "Monorepo" > README.md
$ git add README.md
$ echo -e [tools]nnode = 20.12.2 > .mise.toml
$ git add .mise.toml
$ git commit -m "Root monorepo files"
[main 4b0ef59] Root monorepo files
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
[main 5c365db] Add Frontend feature-e.txt
 1 file changed, 1 insertion(+)
 create mode 100644 feature-e.txt
$ git log
commit 5c365dbe0b01033cf1fb0b82b05b786d353fceb6
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    Add Frontend feature-e.txt

commit dff7720846eb89a87ee7e154bbe58658eb685547
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    Add Frontend feature-a.txt

commit c3adb23c07773201d56b66feb44ddb1dcd2f7573
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    First frontend import
```

Pull `frontend` last commit to `monorepo`:

```sh
$ cd ../monorepo
$ git fetch frontend
Depuis /tmp/tmp.nxfPqzVht3/frontend
   dff7720..5c365db  main       -> frontend/main
$ git merge -X subtree=frontend/ frontend/main --no-edit
Merge made by the 'ort' strategy.
 frontend/feature-e.txt | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 frontend/feature-e.txt
```

This is what the last log lines look like:

```sh
$ git log -n3
commit a98f420d6dc01dee817a9c0af5fe0d2979b6d4a5
Merge: 4b0ef59 5c365db
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    Merge remote-tracking branch 'frontend/main'

commit 4b0ef59dc2b0f0d664f392e7a97cbcfe6d59cebf
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    Root monorepo files

commit 5c365dbe0b01033cf1fb0b82b05b786d353fceb6
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    Add Frontend feature-e.txt
```

You can visit https://github.com/stephane-klein/poc-git-monorepo-multirepos-sync-result-example to see what monorepo looks like at the end of this demo.

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
[main 6f063d4] Add Frontend feature-f.txt
 1 file changed, 1 insertion(+)
 create mode 100644 frontend/feature-f.txt
$ git log
commit 6f063d45b5413c93bb36629f44cd83fc64b093cb
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    Add Frontend feature-f.txt

commit a98f420d6dc01dee817a9c0af5fe0d2979b6d4a5
Merge: 4b0ef59 5c365db
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    Merge remote-tracking branch 'frontend/main'

commit 4b0ef59dc2b0f0d664f392e7a97cbcfe6d59cebf
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    Root monorepo files

commit 5c365dbe0b01033cf1fb0b82b05b786d353fceb6
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    Add Frontend feature-e.txt

commit fd1d878d1bf47a613a779b97cf6810f19a4ded1c
Merge: cb61337 0c7a286
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    Merge backend/main

commit dff7720846eb89a87ee7e154bbe58658eb685547
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    Add Frontend feature-a.txt

commit cb61337fc515d08683961e9fe75fbeebf057db7e
Merge: 8707d00 1e4a508
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    Merge frontend/main

commit 0c7a286bfef0ffc9ad292dc4bafb377cac59bb0e
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    Move all files to backend/

commit c3adb23c07773201d56b66feb44ddb1dcd2f7573
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    First frontend import

commit 8707d00c0702d915f21670b8d7be67d78f978aa9
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    Root commit for monorepo branch main

commit 1e4a508e4d84ddfdc69afcda36418fdd2bd95ede
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    Move all files to frontend/

commit 1bd616cc93a686fedcdc327eaa077f3426f02970
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    Add Backend feature-a.txt

commit 9cf591f583204e1d2055ee6794e0e32ae0226c74
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    First backend import
$ git format-patch --relative -1 HEAD
0001-Add-Frontend-feature-f.txt.patch
$ cat 0001-Add-Frontend-feature-f.txt.patch
From 6f063d45b5413c93bb36629f44cd83fc64b093cb Mon Sep 17 00:00:00 2001
From: stephane-klein <contact@stephane-klein.info>
Date: Sat, 7 Dec 2024 20:37:54 +0100
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
commit 96dc9c70437e8a61dd49d117857a39469ce093b9
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    Add Frontend feature-f.txt

commit 5c365dbe0b01033cf1fb0b82b05b786d353fceb6
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    Add Frontend feature-e.txt

commit dff7720846eb89a87ee7e154bbe58658eb685547
Author: stephane-klein <contact@stephane-klein.info>
Date:   Sat Dec 7 20:37:54 2024 +0100

    Add Frontend feature-a.txt
