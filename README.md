# rsschool-devops-course-tasks

## Overview

This repository contains solutions for the RS School DevOps course tasks. Each task holds Terraform code and/or CI configuration that demonstrates a specific topic.

---

## Task 1 — **Remote State & CI Pipeline**

*Goal:* set up a remote Terraform backend and automate deploys through GitHub Actions.

**What was done**

1. **Remote state** — an S3 bucket and DynamoDB table are created automatically via `bootstrap/` to store and lock Terraform state.
2. **Terraform code** — main configuration (in `terraform/`) provisions a sample S3 bucket and uses the remote backend.
3. **CI/CD** — GitHub Actions workflow runs `fmt`, `plan` and `apply` in three separate jobs using OIDC and an IAM role `GithubActionsRole`.

---

## Task 2 — **AWS VPC Network**

*Goal:* build VPC with public / private subnets, secure access and outbound Internet for private workloads.

**What was done**

1. **Network layout** — VPC `10.0.0.0/16` with two public and two private subnets spread across two AZs.
2. **Internet access** — Internet Gateway for public subnets; NAT Gateway for private subnets.
3. **Security** — Security Groups that open SSH/HTTP/HTTPS only where needed and allow internal traffic.
4. **Bastion host** — a small EC2 instance in a public subnet acts as the single SSH entry point to private hosts.

---

## Task 3 — **Kubernetes Cluster on AWS (k3s)**

*Goal:* spin up a lightweight two-node k3s cluster in private subnets, reachable through a bastion host, and prove it works.

**What was done**

1. **Terraform** — new `terraform/task_3/` config creates  
   * 1 × bastion (public subnet)  
   * 2 × k3s nodes (private subnets, different AZs)  
   * security groups that expose SSH 22 only to the bastion.
2. **k3s install** — script starts k3s server on the first node; the second node joins via token.
3. **Cluster verification** —  
   * on the bastion: `kubectl get nodes` shows **2 Ready** nodes;  
   * on the laptop: SSH tunnel + patched kube-config → the same `kubectl get nodes`.
4. **Workload** — sample nginx pod deployed with  
   ```sh
   kubectl apply -f https://k8s.io/examples/pods/simple-pod.yaml
   ```

---

## Task 4 — **Jenkins on Kubernetes (Minikube)**

*Goal:* deploy Jenkins via Helm on a local Minikube cluster, practise PVC/PV management and JCasC‑driven job definitions.

**What was done**

1. **Helm installation & verification** — 
   * Helm v3 installed locally
   * Bitnami Nginx chart deployed and removed to confirm setup.
2. **Persistent storage** — Minikube add‑ons storage-provisioner & default-storageclass enabled.
3. **Jenkins deployment** — official chart jenkinsci/jenkins installed in a dedicated namespace jenkins with a minimal values.yaml.
4. **Hello‑world freestyle job** — produced via JCasC + Job DSL and prints Hello world to the build log.
5. **Security** —
   * local realm admin user and one extra user created.
   * Hello‑world freestyle job via JCasC + Job DSL created

---

## Task 5 — **Flask App on Kubernetes (Minikube) with Helm**

*Goal:* package a simple Flask application into a Docker image, create a Helm chart, and deploy it on a Minikube cluster.

**What was done**

1. **Docker image** —
   * Created Dockerfile based on Python:3.13.5-alpine.
   * Exposed port 8080 and set CMD to launch the Flask app.
   * Build image via `docker compose build` using docker-compose.yaml
   * Push image `sergei1m/rs-school-flask-app:latest` to Docker Hub.

2. **Helm chart** —
   * Generated template via `helm create helm-chart`.
   * Configured values.yaml:
      ```bash
      replicaCount: 1

      image:
         repository: sergei1m/rs-school-flask-app
         pullPolicy: IfNotPresent
         tag: "latest"

      service:
         type: NodePort
         port: 8080
      ```

3. **Deployment** —
   * Installed chart:
      ```bash
      helm upgrade --install rs-flask helm-chart/ \
      --namespace flask-app \
      --create-namespace \
      --values helm-chart/values.yaml
      ```
   * Verified resources with kubectl get all -n flask-app.
   * Exposed service URL:
      ```bash
      minikube service rs-flask-helm-chart -n flask-app --url
      ```

---

## Task 6 — **Application Deployment via Jenkins Pipeline**

---

## Structure

```
jenkins/                    # Helm values & manifests for Task 4
bootstrap/                  # one‑time remote‑state setup 
terraform/                  # main Terraform configurations 
  ├─ *.tf                   # split into logical files
.github/workflows/          # CI pipelines
  └─ terraform.yml          # fmt, plan, apply
```

## How to Use

### Task 1-3
```bash
# Initialise providers & backend
terraform init

# Review changes
terraform plan  -var-file=env/dev.tfvars

# Apply infrastructure
terraform apply -var-file=env/dev.tfvars

# Destroy when finished
terraform destroy -var-file=env/dev.tfvars
```

### Task 4
* Start local cluster (minikube)
* Install Jenkins using official instruction
* Use jenkins/jenkins-values.yaml for install settings

### Task 5
```bash
# Deploy Flask app via Helm
helm upgrade --install rs-flask helm-chart/ \
--namespace flask-app \
--create-namespace \
--values helm-chart/values.yaml

# Get service URL
minikube service rs-flask-helm-chart -n flask-app --url
```

## Requirements

* **Terraform ≥ 1.6**
* **AWS CLI v2**
* An AWS account with permissions to create the listed resources.
* **Minikube ≥ 1.32 & kubectl**
* **Helm ≥ 3.12**
* **Docker**
