# Contributing Guidelines

Contributions are welcome via GitHub Pull Requests. This document outlines the process to help get your contribution accepted.

Any type of contribution is welcome: new features, bug fixes, documentation improvements, etc.

## How to Contribute

1. Fork this repository, develop, and test your changes.
2. Submit a pull request.

### Requirements

When submitting a PR make sure that:
- It must pass CI jobs for linting and test the changes (if any).
- It must follow [container best practices](https://engineering.bitnami.com/articles/best-practices-writing-a-dockerfile.html).
- The title of the PR is clear enough.
- If necessary, add information to the repository's `README.md`.

### PR Approval and Release Process

1. Changes are manually reviewed by Bitnami team members usually within a business day.
2. Once the changes are accepted, the PR is tested (if needed) into the Bitnami CI pipeline, the container is deployed and tested (verification and functional tests) using docker-compose and Helm (if there is an associated Helm Chart).
3. The PR is merged by the reviewer(s) in the GitHub `master` branch.
4. Then our CI/CD system is going to push the container image to the different registries including the recently merged changes.

***NOTE***: Please note that, in terms of time, may be a slight difference between the appearance of the code in GitHub and the image with the changes in the different registries.
