# k8sPodOp-app
A simple python code wrapped in docker image, used to demonstrate the functionality of KubernetsPodOperator. 

## Build
docker build . -t example_app:test

## Run

ingest data
`docker run -it example_app:test ingest-data`

load data
`docker run -it example_app:test load-data`

