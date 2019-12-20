#!/bin/bash
echo "=============================================================================="
echo "[WARNING] THIS SCRIPT SHOULD BE CALLED USING: source $0"
echo "=============================================================================="
unset DOCKER_TLS_VERIFY
unset DOCKER_HOST
unset DOCKER_CERT_PATH
unset DOCKER_API_VERSION
echo "=============================================================================="
printf "[INFO]\tIf this script was called the right way your 'docker envs'\n\tshould be clean.\n"
echo "=============================================================================="
printf "[TIPS]\t- Check 'docker envs' with: ./check-docker-envs.sh\n\t- Check what 'docker registry' are you using with command:\n\t  docker images\n"
echo "=============================================================================="
