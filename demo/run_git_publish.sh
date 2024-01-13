#!/usr/bin/env bash

# Inspired by https://gist.github.com/joncardasis/e6494afd538a400722545163eb2e1fa5

set -euo pipefail
IFS=$'\n\t'

[[ -f "/.dockerenv" ]] || { printf "Error: must be executed inside Docker container\n" 1>&2; exit 1; }

# Gets the name of the repo from ENV_GIT_REPO_URL
# Ex: https://github.com/flemay/3musketeers.git -> 3musketeers
getRepoName() {
    declare -n _retRepoName="${1}"
    _retRepoName="${ENV_GIT_REPO_URL:?##*/}"
    _retRepoName="${_retRepoName%.git}"
}

getRepoTmpDir() {
    declare -n _retRepoTmpDir="${1}"
    local _repoName=""
    getRepoName _repoName
    _retRepoTmpDir="${ENV_TMP_DIR?}/${_repoName}"
}

# https://stackoverflow.com/questions/72577367/git-push-provide-credentials-without-any-prompts
gitAuth() {
    # shellcheck disable=SC2016
    git -c credential.helper= \
        -c credential.helper='!f() { echo "username=${ENV_GIT_USERNAME:?}"; echo "password=${ENV_GIT_TOKEN:?}"; };f' \
    "$@"
}

cloneAndSetPublishBranch() {
    # Clone the repository to a tmp dir so that the current code is not messed uo
    # The use of option `--single-branch` is to make sure only the default branch is downloaded. This can save some bandwith
    local _repoTmpDir=""
    getRepoTmpDir _repoTmpDir
    rm -fr "${_repoTmpDir:?}"
    gitAuth clone --single-branch "${ENV_GIT_REPO_URL:?}" "${_repoTmpDir}"

    cd "${_repoTmpDir}"
    local _currentBranch=""
    _currentBranch=$(git rev-parse --abbrev-ref HEAD)
    if [[ "${ENV_PUBLISH_BRANCH:?}" == "${_currentBranch}" ]]; then
        printf "Error: ENV_PUBLISH_BRANCH cannot be '%s'\n" "${_currentBranch}"
        exit 1
    fi

    # Create a new orphan branch (which has no history and tracked files)
    # According to Git (https://git-scm.com/docs/git-switch/2.23.0):
    # --orphan <new-branch>
    #     Create a new orphan branch, named <new-branch>. All tracked files are removed.
    git branch -D "${ENV_PUBLISH_BRANCH:?}" &> /dev/null || true
    git switch --orphan "${ENV_PUBLISH_BRANCH:?}"

    # create a new .gitignore specifically for publish branch
    printf "*\n" > .gitignore
    {
        printf "!.gitignore\n"
        printf "!assets\n"
        printf "!assets/*.mp4\n"
    } >> .gitignore

    cp -r "${ENV_PUBLISH_DIR:?}"/* .
}

configureGitConfig() {
    git config user.email "${ENV_GIT_EMAIL:?}"
    git config user.name "${ENV_GIT_NAME:?}"
    git remote remove originForPublishing &> /dev/null || true
    git remote add originForPublishing "${ENV_GIT_REPO_URL:?}"
}

commitAndPush() {
    git add .
    git commit -m "Publish demo"
    # shellcheck disable=SC2310
    gitAuth push originForPublishing -d "${ENV_PUBLISH_BRANCH:?}" &> /dev/null || true
    gitAuth push originForPublishing "${ENV_PUBLISH_BRANCH:?}"
}

cleanup() {
    local _repoTmpDir=""
    getRepoTmpDir _repoTmpDir
    rm -fr "${_repoTmpDir}"
}

cloneAndSetPublishBranch
configureGitConfig
commitAndPush
cleanup
