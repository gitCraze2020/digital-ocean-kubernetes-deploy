# the following env variables need to be set in the project on clusterci.com:
#
# DOCKERHUB_USERNAME and DOCKERHUB_PASS, these are relatively static
#
# KUBERNETES_TOKEN, KUBERNETES_SERVER, and KUBERNETES_CLUSTER_CERTIFICATE.
echo go here to add circleci project variables:
echo https://circleci.com/gh/gitCraze2020/digital-ocean-kubernetes-deploy/edit#env-vars

# The value of KUBERNETES_TOKEN will be the value of the local environment variable
# used earlier to authenticate on your Kubernetes cluster using your Service Account user.
# If you have closed the terminal, you can always run the following command to retrieve it again:

TMP_FILE_NAME=cicd-token.txt
TMP_TOKEN=$(kubectl get secret $(kubectl get secret | grep cicd-token | awk '{print $1}') -o jsonpath='{.data.token}' | base64 --decode)
echo $TMP_TOKEN > "./$TMP_FILE_NAME"
# for now, add it manually to the circleci.com project, so copy over to the mac host side
cp $TMP_FILE_NAME ~/VM-shared-folder/CircleCI-do-sample-app/.
# make sure to exclude from github
grep -qF -- $TMP_FILE_NAME ".gitignore" || echo $TMP_FILE_NAME >> .gitignore

# KUBERNETES_SERVER will be the string you passed as the -- server flag to kubectl when you logged
# in with your cicd Service Account. You can find this after server:
# in the ~/.kube/config file, or in the file kubernetes-deployment-tutorial-kubeconfig.yaml
# downloaded from the DigitalOcean dashboard when you made the initial setup of your Kubernetes cluster.


#warnings:
#this assumes current config context has the intended cluster (and server)
#and assumes the first cluster in the list is the intended server
TMP_FILE_NAME=cluster-server-address.txt
TMP_SERVER=$(kubectl config view -o jsonpath='{.clusters[0].cluster.server}')
echo $TMP_SERVER > "./$TMP_FILE_NAME"
# for now, add it manually to the circleci.com project, so copy over to the mac host side
cp $TMP_FILE_NAME ~/VM-shared-folder/CircleCI-do-sample-app/.
# make sure to exclude from github
grep -qF -- $TMP_FILE_NAME ".gitignore" || echo $TMP_FILE_NAME >> .gitignore

# we don't need this
###kubectl --insecure-skip-tls-verify --kubeconfig=/dev/null --namespace=cwex3 --server="$TMP_SERVER" --token="$TOKEN" get pods


# KUBERNETES_CLUSTER_CERTIFICATE should also be available on your ~/.kube/config file.
# It’s the certificate-authority-data field on the clusters item related to your cluster. 
# It should be a long string; make sure to copy all of it.
# Those environment variables must be defined on circleci's env var site because most of them contain
# sensitive information, and
# it is not secure to place them directly on the CircleCI YAML config file.
# 
TMP_FILE_NAME=cluster-certificate-authority-data.txt
TMP_DATA=$(kubectl config view --raw -o jsonpath='{.clusters[0].cluster.certificate-authority-data}')
echo $TMP_DATA > "./$TMP_FILE_NAME"
# for now, add it manually to the circleci.com project, so copy over to the mac host side
cp $TMP_FILE_NAME ~/VM-shared-folder/CircleCI-do-sample-app/.
# make sure to exclude from github
grep -qF -- $TMP_FILE_NAME ".gitignore" || echo $TMP_FILE_NAME >> .gitignore


#name must be lower case!
TMP_DOCKERHUB_USERNAME=dockercraze
TMP_APP_NAME=do-kubernetes-sample-app

# add this content to new config ./.circleci/config.yml
# \$VAR needs to be $VAR in the output
# yes, the extension is yml, it seems CircleCI requires exactly that name
#
# This sets up a Workflow with a single job, called build, that runs for
# every commit to the master branch. This job is using the image
# circleci/buildpack-deps:stretch to run its steps, which is an image from
# CircleCI based on the official buildpack-deps Docker image, but with some extra tools
# installed, like Docker binaries themselves.
#
# Run these in the project source root folder, create folder:
mkdir .circleci
TMP_FILE_NAME=.circleci/config.yml
cat > $TMP_FILE_NAME << EOL
#################################################################################
version: 2.1
jobs:
  build:
    docker:
      - image: circleci/buildpack-deps:stretch
    environment:
      IMAGE_NAME: "$TMP_DOCKERHUB_USERNAME/$TMP_APP_NAME"
    working_directory: ~/app
    steps:
      # retrieve the code from GitHub
      - checkout
      # set up a remote, isolated environment for each build
      # this is required before using any docker command inside a job step
      # as those steps really need to be run on another machine
      - setup_remote_docker
      # first run step builds the image, used to be done locally when manual
      - run:
          name: Build Docker image
          command: |
            docker build -t \$IMAGE_NAME:latest .
      # last run step pushes the image to DockerHub, possible now that the
      # login authentication is made possible using the environment variables set earlier
      # in the circleci project settings
      - run:
          name: Push Docker Image
          command: |
            echo "\$DOCKERHUB_PASS" | docker login -u "\$DOCKERHUB_USERNAME" --password-stdin
            # circle_sha1 is a special default variable, contains the hash of the commit
            # that it is building. Used here to ensure a new unique specific image
            docker tag \$IMAGE_NAME:latest \$IMAGE_NAME:\$CIRCLE_SHA1
            docker push \$IMAGE_NAME:latest
            docker push \$IMAGE_NAME:\$CICRLE_SHA1
            # next, edit kube/do-sample-deployment.yml
            # which needs to point to the same image sing this circleci variable
workflows:
  version: 2
  build-master:
    jobs:
      - build:
          filters:
            branches:
              only: master
#################################################################################
EOL

