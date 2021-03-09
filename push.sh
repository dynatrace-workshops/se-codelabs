npm run build

# gulp dist is creating a symbolic link to codelabs, but since we are shipping only the dist directory we need
# to copy the codelabs inside the dist directory
rm -rf dist/codelabs
cp -r codelabs/ dist/

docker build . -t codelabs:latest

docker tag codelabs:latest registry.lab.dynatrace.org/cloudplatform/codelabs:latest

docker push registry.lab.dynatrace.org/cloudplatform/codelabs:latest

# deploy new version to kubernetes
# this currently results in some downtime, but as soon as we have a jenkins pipeline we can use the kubernetes
# rolling update feature
cd k8s
kubectl delete deployment.apps klu-codelabs
kubectl apply -n klu-codelabs -f deployment.yaml

