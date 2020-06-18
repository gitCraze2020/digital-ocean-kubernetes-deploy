#!/bin/bash
TMP_GIT_USER_NAME=gitCraze2020
TMP_REPO_NAME=digital-ocean-kubernetes-deploy
TMP_APP_NAME=do-kubernetes-sample-app
TMP_FILE_NAME=.circleci/config.yaml

cat > $TMP_FILE_NAME << EOL
#################################################################################
version: 2.1 jobs:
  build:
    docker:
      - image: circleci/buildpack-deps:stretch
    environment:
      IMAGE_NAME: "$TMP_GIT_USER_NAME/$TMP_APP_NAME"
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
            docker build -t $IMAGE_NAME:latest .
      # last run step pushes the image to DockerHub, possible now that the
      # login authentication is made possible using the environment variables set earlier
      # in the circleci project settings
      - run:
          name: Push Docker Image
          command: |
            echo "\$DOCKERHUB_PASS" | docker login -u "\$DOCKERHUB_USERNAME" --password-stdin
            docker push \$IMAGE_NAME:latest
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
