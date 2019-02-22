#!/bin/sh

set -e

case ${STATUS} in
	started)
		curl -sS https://api.rollbar.com/api/1/deploy/ \
			-F access_token="${ROLLBAR_ACCESS_TOKEN}" \
			-F environment="${ROLLBAR_ENV}" \
			-F revision="${DRONE_COMMIT_SHA}" \
			-F local_username="${DRONE_COMMIT_AUTHOR}" \
			-F status="started" \
			| jq .data.deploy_id > rollbar_deploy_id.txt
		echo "Rollbar notified of deployment start, ID: $(cat rollbar_deploy_id.txt)"
		;;
	updated)
		case ${DRONE_JOB_STATUS} in
			success)
				curl -X PATCH -sS https://api.rollbar.com/api/1/deploy/$(cat rollbar_deploy_id.txt)/?access_token=${ROLLBAR_ACCESS_TOKEN} \
					-F status="succeeded"
				echo "Rollbar notified of successful deployment, ID: $(cat rollbar_deploy_id.txt)"
		    ;;
			failure)
				curl -X PATCH -sS https://api.rollbar.com/api/1/deploy/$(cat rollbar_deploy_id.txt)/?access_token=${ROLLBAR_ACCESS_TOKEN} \
					-F status="failed"
				;;
		esac
		;;
	*)
		echo "'status' not set or invalid in .drone.yml'"
		exit 1
		;;
esac
