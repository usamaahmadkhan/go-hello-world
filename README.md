# GOLang Hello World App

Hello World Golang app to demonstrate DevSecOps Pipeline to run on k8s Reliably.
A light weight web app for demo puproses only.

## DevSecOps pipeline
Uses `Snyk` for

- Static Code Analysis
- Image Scanning
- Kubernetes IaC analysis

## Build Image
```
make docker-build
```

## Push Image
```
make docker-push
```

## Run Locally
```
make run
```

## Run on Kubernetes

To run the latest version:
```
kubectl apply -f https://github.com/usamaahmadkhan/go-hello-world/tree/main/kubernetes
```
