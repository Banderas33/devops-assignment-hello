# DevOps Assignment - Flask App

## Overview

This project demonstrates a DevOps workflow for a Flask application.

The project includes:

- Flask application
- Dockerfile
- Helm chart for Kubernetes deployment
- Terraform code for AWS infrastructure
- GitHub Actions pipeline

The original assignment requires AWS EKS, ECR, VPC, public/private subnets, IAM roles and S3 for Terraform state.

EKS is included in the Terraform code, but disabled by default to avoid AWS costs.

---

## Project Structure

```text
app/                 Flask application
Dockerfile           Docker image definition
requirements.txt     Python dependencies
helm/hello-app        Helm chart
terraform/           AWS infrastructure code
.github/workflows    GitHub Actions workflow
README.md            Project documentation
```

---

## Application Endpoints

Main endpoint:

```text
/
```

Returns:

```text
Hello from Flask app running in Kubernetes!
```

Health check endpoint:

```text
/health
```

Returns:

```json
{"status":"ok"}
```

---

## Run Flask Locally

Install dependencies:

```bash
python -m pip install -r requirements.txt
```

Run the app:

```bash
python app/app.py
```

Open in browser:

```text
http://localhost:5000
```

Health check:

```text
http://localhost:5000/health
```

---

## Docker

Build the Docker image:

```bash
docker build -t hello-flask-app:local .
```

Run the container:

```bash
docker run -d -p 5000:5000 --name hello-flask hello-flask-app:local
```

Open in browser:

```text
http://localhost:5000
```

Health check:

```text
http://localhost:5000/health
```

Stop and remove the container:

```bash
docker stop hello-flask
docker rm hello-flask
```

---

## Kubernetes with Helm

This project was tested with local Kubernetes using Docker Desktop.

Install the app with Helm:

```bash
helm install hello-app helm/hello-app
```

Check Kubernetes resources:

```bash
kubectl get pods
kubectl get svc
helm list
```

If NodePort does not work locally, use port-forward:

```bash
kubectl port-forward svc/hello-app 5000:5000
```

Open in browser:

```text
http://localhost:5000
```

Health check:

```text
http://localhost:5000/health
```

Uninstall the Helm release:

```bash
helm uninstall hello-app
```

---

## Terraform

Terraform code is located in the `terraform` folder.

It defines:

- S3 bucket for Terraform state
- VPC
- Public subnet
- Private subnet
- Internet Gateway
- Public route table
- ECR repository
- IAM roles for EKS
- Optional EKS cluster
- Optional EKS node groups

Go into the Terraform folder:

```bash
cd terraform
```

Initialize Terraform:

```bash
terraform init
```

Validate the Terraform files:

```bash
terraform validate
```

Preview the infrastructure plan:

```bash
terraform plan
```

---

## Terraform Variables

The example variables file is:

```text
terraform/terraform.tfvars.example
```

Example values:

```hcl
aws_region   = "eu-west-1"
project_name = "hello-devops"

enable_eks = false
```

To use it locally, copy it to `terraform.tfvars`.

On Windows PowerShell:

```powershell
Copy-Item terraform.tfvars.example terraform.tfvars
```

On Linux/macOS:

```bash
cp terraform.tfvars.example terraform.tfvars
```

---

## Cost Safety

EKS is not free.

For cost safety, EKS is disabled by default:

```hcl
enable_eks = false
```

When `enable_eks` is `false`, Terraform will not create:

- EKS cluster
- EKS public node group
- EKS private node group

To include EKS in the Terraform plan intentionally:

```bash
terraform plan -var="enable_eks=true"
```

To create EKS intentionally:

```bash
terraform apply -var="enable_eks=true"
```

Do not run this unless you accept the AWS cost.

---

## Terraform Apply

To create the non-EKS infrastructure:

```bash
terraform apply
```

This creates resources such as:

- VPC
- Subnets
- Internet Gateway
- Route table
- S3 bucket
- ECR repository
- IAM roles

To destroy the infrastructure:

```bash
terraform destroy
```

---

## ECR

The Terraform code creates an ECR repository for Docker images.

After running Terraform apply, the ECR repository URL is shown in the outputs.

The Docker image can later be pushed to ECR and used by EKS.

---

## GitHub Actions

The GitHub Actions workflow is located here:

```text
.github/workflows/ci-cd.yml
```

The pipeline runs on push to the `main` branch.

It performs:

- Checkout repository
- Docker build
- Helm lint
- Terraform init
- Terraform validate

The pipeline does not create AWS resources.

---

## Current Deployment Method

For cost safety, the application was deployed locally using:

- Docker Desktop
- Local Kubernetes
- Helm

The app was accessed using:

```bash
kubectl port-forward svc/hello-app 5000:5000
```

Then opened at:

```text
http://localhost:5000
```

---

## Notes

This project includes the required EKS Terraform code, but EKS is disabled by default to avoid unnecessary AWS costs.

For a real AWS deployment, the next steps would be:

1. Set `enable_eks = true`
2. Run Terraform apply
3. Push the Docker image to ECR
4. Configure kubectl to connect to EKS
5. Deploy the Helm chart to EKS
6. Expose the application using LoadBalancer or Ingress