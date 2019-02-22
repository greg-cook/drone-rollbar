# drone-rollbar-deploy
[Drone](https://drone.io) plugin to notify [Rollbar](https://rollbar.com) of a deployment

Notifies Rollbar when starting a deployment and updates the status of the deployment using the value of `DRONE_JOB_STATUS`

## Usage

* Add your Rollbar project's `post_server_item` token to your Drone repository secrets.
* Update the value of `rollbar_env` to the corresponding Rollbar environment. (staging, production, etc.)

**NOTE:** This plugin will write a temporary file `rollbar_deploy_id.txt` to the project's directory when creating a deploy. This is so we can use the deployment ID in the following `update` step. Depending on your Pipeline you may need to ignore this file.

```yml
pipeline:

  rollbar-deploy-start:
    image: gregcook/drone-rollbar-deploy
    status: started
    rollbar_env: <environment>
    secrets:
      - rollbar_access_token

  deploy-my-thing:
    image: my-deployment/image
    commands:
      - deploy --all-the-things

  rollbar-deploy-update:
    image: gregcook/drone-rollbar-deploy
    status: updated
    secrets:
      - rollbar_access_token
```
