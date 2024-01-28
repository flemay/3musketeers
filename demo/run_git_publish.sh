#!/usr/bin/env bash

# Inspired by https://gist.github.com/joncardasis/e6494afd538a400722545163eb2e1fa5

set -euo pipefail
IFS=$'\n\t'

[[ -f "/.dockerenv" ]] || { printf "Error: must be executed inside Docker container\n" 1>&2; exit 1; }

envGitEmail="${ENV_GIT_EMAIL:?}"
envGitName="${ENV_GIT_NAME:?}"
envGitPublishBranch="${ENV_GIT_PUBLISH_BRANCH:?}"
envGitPublishIncludePatterns="${ENV_GIT_PUBLISH_INCLUDE_PATTERNS:?}"
envGitRepoURL="${ENV_GIT_REPO_URL:?}"
# shellcheck disable=SC2034
envGitToken="${ENV_GIT_TOKEN:?}"
# shellcheck disable=SC2034
envGitUsername="${ENV_GIT_USERNAME:?}"
envPublishDir="${ENV_PUBLISH_DIR:?}"
envTmpDir="${ENV_TMP_DIR:?}"

# Gets the name of the repo from envGitRepoURL
# Ex: https://github.com/flemay/3musketeers.git -> 3musketeers
getRepoName() {
    printf "function: getRepoName\n"
    declare -n _retRepoName="${1}"
    _retRepoName="${envGitRepoURL##*/}"
    _retRepoName="${_retRepoName%.git}"
}

getRepoTmpDir() {
    printf "function: getRepoTmpDir\n"
    declare -n _retRepoTmpDir="${1}"
    local _repoName=""
    getRepoName _repoName
    _retRepoTmpDir="${envTmpDir}/${_repoName}"
}

# https://git-scm.com/docs/gitfaq#Documentation/gitfaq.txt-HowdoIreadapasswordortokenfromanenvironmentvariable
# https://stackoverflow.com/questions/72577367/git-push-provide-credentials-without-any-prompts
# Notes
# - The helper line could've been written like `-c credential.helper="!f() { echo \"username=${envGitUsername}\"; echo \"password=${envGitToken}\"; };f" \` but decided to leave git to evaluate the value when Git runs the command.
# - Possible leak: Be sure the helper code is correct. For instance, if we put `password${ENV_GIT_TOKEN}` (omiting the `=`), the command will leak the token with the following message: "warning: invalid credential line: passwordgithub_pat[REDACTED]".
gitAuth() {
    printf "function: gitAuth\n"
    # shellcheck disable=SC2016
    git -c credential.helper= \
        -c credential.helper='!f() { echo "username=${ENV_GIT_USERNAME:?}"; echo "password=${ENV_GIT_TOKEN:?}"; };f' \
    "$@"
    # -c credential.helper="!f() { echo \"username=${envGitUsername}\"; echo \"password=${envGitToken}\"; };f" \
}

cloneAndSetPublishBranch() {
    # Clone the repository to a tmp dir so that the current code is not messed up
    # The use of option `--single-branch` is to make sure only the default branch is downloaded. This can save some bandwith
    printf "function: cloneAndSetPublishBranch\n"
    local _repoTmpDir=""
    getRepoTmpDir _repoTmpDir
    rm -fr "${_repoTmpDir:?}"
    gitAuth clone --single-branch "${envGitRepoURL}" "${_repoTmpDir}"

    cd "${_repoTmpDir}"
    local _currentBranch=""
    _currentBranch=$(git rev-parse --abbrev-ref HEAD)
    if [[ "${envGitPublishBranch}" == "${_currentBranch}" ]]; then
        printf "Error: ENV_PUBLISH_BRANCH cannot be '%s'\n" "${_currentBranch}"
        exit 1
    fi

    # Create a new orphan branch (which has no history and tracked files)
    # According to Git (https://git-scm.com/docs/git-switch/2.23.0):
    # --orphan <new-branch>
    #     Create a new orphan branch, named <new-branch>. All tracked files are removed.
    git branch -D "${envGitPublishBranch}" &> /dev/null || true
    git switch --orphan "${envGitPublishBranch}"

    # create a new .gitignore specifically for publish branch
    printf "*\n" > .gitignore
    IFS=',' read -ra _includePatterns <<< "${envGitPublishIncludePatterns}"
    for pattern in "${_includePatterns[@]}"; do
        printf "!%s\n" "${pattern}" >> .gitignore
    done

    cp -r "${envPublishDir}"/* .
}

configureGitConfig() {
    printf "function: configureGitConfig\n"
    git config user.email "${envGitEmail}"
    git config user.name "${envGitName}"
    git remote remove originForPublishing &> /dev/null || true
    git remote add originForPublishing "${envGitRepoURL}"
}

commitAndPush() {
    printf "function: commitAndPush\n"
    git add .
    git commit -m "Publish"
    # shellcheck disable=SC2310
    gitAuth push originForPublishing -d "${envGitPublishBranch}" &> /dev/null || true
    gitAuth push originForPublishing "${envGitPublishBranch}"
}

cleanup() {
    printf "function: cleanup\n"
    local _repoTmpDir=""
    getRepoTmpDir _repoTmpDir
    rm -fr "${_repoTmpDir}"
}

cloneAndSetPublishBranch
configureGitConfig
commitAndPush
cleanup
