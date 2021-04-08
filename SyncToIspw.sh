#!/bin/bash

echo "INPUT_SHOWENV=${INPUT_SHOWENV}"
echo "INPUT_ENCRYPTIONPROTOCOL=${INPUT_ENCRYPTIONPROTOCOL}"
echo "INPUT_CODEPAGE=${INPUT_CODEPAGE}"
echo "INPUT_TIMEOUT=${INPUT_TIMEOUT}"

if [[ ! -z ${INPUT_SHOWENV} ]] ; then
    echo "CI=$CI"
    echo "GITHUB_WORKFLOW=$GITHUB_WORKFLOW"
    echo "GITHUB_RUN_ID=$GITHUB_RUN_ID"
    echo "GITHUB_RUN_NUMBER=$GITHUB_RUN_NUMBER"
    echo "GITHUB_JOB=$GITHUB_JOB"
    echo "GITHUB_ACTION=$GITHUB_ACTION"
    echo "GITHUB_ACTIONS=$GITHUB_ACTIONS"
    echo "GITHUB_ACTOR=$GITHUB_ACTOR"
    echo "GITHUB_REPOSITORY=$GITHUB_REPOSITORY"
    echo "GITHUB_EVENT_NAME=$GITHUB_EVENT_NAME"
    echo "GITHUB_EVENT_PATH=$GITHUB_EVENT_PATH"
    echo "GITHUB_WORKSPACE=$GITHUB_WORKSPACE"
    echo "GITHUB_SHA=$GITHUB_SHA"
    echo "GITHUB_REF=$GITHUB_REF"
    echo "GITHUB_HEAD_REF=$GITHUB_HEAD_REF"
    echo "GITHUB_BASE_REF=$GITHUB_BASE_REF"
    echo "GITHUB_SERVER_URL=$GITHUB_SERVER_URL"
    echo "GITHUB_API_URL=$GITHUB_API_URL"
    echo "GITHUB_GRAPHQL_URL=$GITHUB_GRAPHQL_URL"
fi

GIT_REPO=$GITHUB_SERVER_URL/$GITHUB_REPOSITORY.git
GIT_DELTA_FILES=$( git diff-tree --no-commit-id --name-only -r $GITHUB_SHA | sed -z 's/\n/:/g;s/:$//' )
GIT_BRANCH=$( echo ${GITHUB_REF#refs/heads/} )

if [[ ! -z ${INPUT_SHOWENV} ]] ; then 
    echo "GIT_REPO=$GIT_REPO"
    echo "GIT_BRANCH=$GIT_BRANCH"
    echo "GIT_DELTA_FILES=$GIT_DELTA_FILES"

    echo "INPUT_HOST=$INPUT_HOST"
    echo "INPUT_PORT=$INPUT_PORT"
    echo "INPUT_UID=${INPUT_UID}"
    echo "INPUT_RUNTIMECONFIGURATION=${INPUT_RUNTIMECONFIGURATION}"
    echo "INPUT_STREAM=$INPUT_STREAM"
    echo "INPUT_APPLICATION=$INPUT_APPLICATION"
    echo "INPUT_CHECKOUTLEVEL=$INPUT_CHECKOUTLEVEL"
    echo "INPUT_GITUID=${INPUT_GITUID}"

    echo "INPUT_CONTAINERCREATION=${INPUT_CONTAINERCREATION}"
    echo "INPUT_CONTAINERDESCRIPTION=${INPUT_CONTAINERDESCRIPTION}"
fi

if [[ -z ${INPUT_CONTAINERCREATION} ]] ; then
    INPUT_CONTAINERCREATION="per-commit"
fi

extra_args=""

if [[ ! -z ${INPUT_CONTAINERDESCRIPTION} ]] ; then
    extra_args="-ispwContainerDescription ${INPUT_CONTAINERDESCRIPTION}"
fi

if [[ ! -z ${INPUT_ENCRYPTIONPROTOCOL} ]] ; then
    extra_args="${extra_args} -protocol ${INPUT_ENCRYPTIONPROTOCOL}"
fi

if [[ ! -z ${INPUT_CODEPAGE} ]] ; then
    extra_args="${extra_args} -code ${INPUT_CODEPAGE}"
fi

if [[ ! -z ${INPUT_TIMEOUT} ]] ; then
    extra_args="${extra_args} -timeout ${INPUT_TIMEOUT}"
fi

if [[ ! -z ${INPUT_SHOWENV} ]] ; then 
    echo "INPUT_CONTAINERCREATION=${INPUT_CONTAINERCREATION}"
    echo "extra_args=${extra_args}"
    echo "cmd=/TopazCliInstall/IspwCLI.sh -host $INPUT_HOST -port $INPUT_PORT -id ${INPUT_UID} -pass *** -operation syncGitToIspw -ispwServerConfig ${INPUT_RUNTIMECONFIGURATION} -ispwServerStream $INPUT_STREAM -ispwServerApp $INPUT_APPLICATION -ispwCheckoutLevel ${INPUT_CHECKOUTLEVEL} -gitRepoUrl $GIT_REPO -gitUsername ${INPUT_GITUID} -gitPassword *** -ispwContainerCreation ${INPUT_CONTAINERCREATION} -gitBranch $GIT_BRANCH -gitCommit $GIT_DELTA_FILES  -gitFromHash -1 -targetFolder $GITHUB_WORKSPACE -gitLocalPath $GITHUB_WORKSPACE ${extra_args}"
fi 

/TopazCliInstall/IspwCLI.sh -host $INPUT_HOST -port $INPUT_PORT -id ${INPUT_UID} -pass $INPUT_PASS -operation syncGitToIspw -ispwServerConfig ${INPUT_RUNTIMECONFIGURATION} -ispwServerStream $INPUT_STREAM -ispwServerApp $INPUT_APPLICATION -ispwCheckoutLevel ${INPUT_CHECKOUTLEVEL} -gitRepoUrl $GIT_REPO -gitUsername ${INPUT_GITUID} -gitPassword ${INPUT_GITPASS} -ispwContainerCreation ${INPUT_CONTAINERCREATION} -gitBranch $GIT_BRANCH -gitCommit $GIT_DELTA_FILES  -gitFromHash -1 -targetFolder $GITHUB_WORKSPACE -gitLocalPath $GITHUB_WORKSPACE ${extra_args}

automaticBuildJson="{}"
if [[ -f "${GITHUB_WORKSPACE}/automaticBuildParams.txt" ]] ; then
    automaticBuildJson=$( cat ${GITHUB_WORKSPACE}/automaticBuildParams.txt )
    automaticBuildJson="${automaticBuildJson//'%'/'%25'}"
    automaticBuildJson="${automaticBuildJson//$'\n'/'%0A'}"
    automaticBuildJson="${automaticBuildJson//$'\r'/'%0D'}"
else
    echo "${GITHUB_WORKSPACE}/automaticBuildParams.txt doesn't exist"
fi

echo "::set-output name=automaticBuildJson::${automaticBuildJson}"

changedProgramsJson={}
if [[ -f "${GITHUB_WORKSPACE}/changedPrograms.json" ]] ; then
    changedProgramsJson=$( cat ${GITHUB_WORKSPACE}/changedPrograms.json )
    changedProgramsJson="${changedProgramsJson//'%'/'%25'}"
    changedProgramsJson="${changedProgramsJson//$'\n'/'%0A'}"
    changedProgramsJson="${changedProgramsJson//$'\r'/'%0D'}"
else
    echo "${GITHUB_WORKSPACE}/changedPrograms.json doesn't exist"
fi

echo "::set-output name=changedProgramsJson::${changedProgramsJson}"
