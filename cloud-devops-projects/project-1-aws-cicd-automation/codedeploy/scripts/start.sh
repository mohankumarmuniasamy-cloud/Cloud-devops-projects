#!/bin/bash
set -e

docker run -d --name aws-cicd-demo -p 80:80 -v /opt/aws-cicd-demo/html/index.html:/usr/share/nginx/html/index.html:ro nginx:alpine
