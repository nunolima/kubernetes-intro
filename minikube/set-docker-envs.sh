#!/bin/bash
echo "=============================================================================="
echo "[WARNING] THIS SCRIPT SHOULD BE CALLED USING: source $0"
echo "=============================================================================="
eval $(minikube docker-env)
printf "[INFO]\tIf this script was called the right way your 'docker envs'\n\tshould be setted.\n\tNow you will be able to use the minikube internal docker registry.\n\tTo get back using your local host 'docker registry' run:\n\tsource ./unset-docker-envs.sh\n"
echo "=============================================================================="
printf "[TIPS]\t- Check 'docker envs' with: ./check-docker-envs.sh\n\t- Check what 'docker registry' are you using with command:\n\t  docker images\n"
echo "=============================================================================="
