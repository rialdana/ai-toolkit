---
title: Use Noun-Verb Pattern for Subcommands
impact: HIGH
tags: structure, consistency, ux
---

## Use Noun-Verb Pattern for Subcommands

Organize subcommands using a consistent noun-verb pattern where the noun identifies the resource and the verb identifies the action.

**Incorrect (inconsistent verb-noun mixing, ambiguous structure):**

```bash
# Inconsistent patterns
mycli start-container
mycli container-stop
mycli deleteImage
mycli network list

# Ambiguous structure
mycli run container prod
mycli container run prod
```

**Correct (consistent noun-verb pattern):**

```bash
# Docker-style noun-verb pattern
docker container start
docker container stop
docker image delete
docker network list

# Alternative: kubectl-style verb-noun pattern (pick one and be consistent)
kubectl get pods
kubectl delete service
kubectl create deployment
kubectl describe node

# Simple tools can use direct verbs
git commit
git push
npm install
```

**Why it matters:** Consistent subcommand structure makes commands predictable and easier to remember. Users can guess the correct command based on the pattern. Mixing patterns (noun-verb and verb-noun) creates cognitive overhead and increases errors.

Reference: [clig.dev - Subcommands](https://clig.dev/#subcommands)
