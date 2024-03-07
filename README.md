# 🤘 MERN CRUD app
[Terraform Installation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
### Install awscli on your linux machine
```console
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws configure set region $AWS_REGION
```
### Provision EKS cluster
```console
cd terraform-provisioning
terraform init
terraform validate
terraform plan
terrform apply
```
*Notice:* We need to keep our tfstate file in S3 bucket for Concurrency, Security, Remote Locking Purpose
### Install MERN-CRUD application on EKS Cluster
```console
cd mongodb
helm install mongo --set auth.enabled=false,replicaSet.enabled=true,service.type=LoadBalancer,replicaSet.replicas.secondary=3 bitnami/mongodb
cd -
cd server
helm install backend backend/chart/backend
cd -
cd client
helm install frontend frontend/chart/frontend
```
### Install ArgoCD on your cluster
Configure as per ArgoCD document [ArgoCD](https://argo-cd.readthedocs.io/en/stable/).
### Install ELK stack in your cluster for Log Monitoring Purpose
helm install my-release oci://registry-1.docker.io/bitnamicharts/elasticsearch
### Install Prometheus Grafana in your cluster for Metrics Monitoring Purpose
# Installing Prometheus & Grafana via Helm Chart
```console
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```
```console
helm repo update
```
```console
helm install alab-prometheus --kubeconfig /etc/rancher/k3s/k3s.yaml prometheus-community/prometheus
```
```console
helm repo add grafana https://grafana.github.io/helm-charts
```
```console
helm repo update
```
```console
helm install alab-grafana --kubeconfig /etc/rancher/k3s/k3s.yaml grafana/grafana
 ```
```console
 export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=alab-grafana" -o jsonpath="{.items[0].metadata.name}")
     kubectl --namespace default port-forward $POD_NAME 3000
```
## Login grafana with username admin & password from the following command
```console
kubectl get secret --namespace default alab-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```
## Enahancing Security for API keys and credentials
This can be achived by using secrets resources  for all credentials; AWS Secret Manager or Hashicorp Vault can be used for this purpose. 

### For Autoscaling we can implement hpa on deployment resources. Further, this can be customized based on any http request, meaning we can add more node or reduce node based on the http requests or based on any triggered events.
### This is an example how can be manage node group based on event.
```console
apiVersion: v1
kind: ConfigMap
metadata:
  name: cluster-autoscaler-config
data:
  config.json: |
    {
      "apiVersion": "1.0",
      "kind": "ClusterAutoscalerConfiguration",
      "enabled": true,
      "scaleDownUtilizationThreshold": 0.5,
      "balanceSimilarNodeGroups": true,
      "expander": "random",
      "enableScaleDown": true,
      "scaleDownDelayAfterAdd": "10m",
      "scaleDownDelayAfterFailure": "3m",
      "scaleDownUnneededTime": "10m",
      "scaleDownUnreadyTime": "20m",
      "scaleDownDelayAfterDelete": "0s",
      "scanInterval": "10s",
      "maxNodesTotal": 10,
      "provider": "aws",
      "awsRegion": "us-west-2",
      "awsNodeGroup": "your-node-group",
      "cloudProviderConfig": {
        "overrides": {
          "enable_http_request_scaling": true,
          "target_http_request_per_second": 100
        }
      }
    }
```
### On modifying the image tag in values.yaml, ARGO CD automatically deploys new image on the cluster.   
