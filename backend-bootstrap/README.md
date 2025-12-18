To finish your project setup, you should organize your files into two separate directories. This prevents Terraform from trying to manage your "storage" and your "servers" in the same state file, which is a key industry best practice.

Here is the finalized structure and the updated `README.md` to reflect this organization.

### Proposed Folder Structure

```text
/terraform-jenkins-project
│
├── /backend-bootstrap         # PART 1: Run this first
│   ├── main.tf               # S3 and DynamoDB resources
│   └── outputs.tf            # Exports bucket/table names
│
└── /jenkins-infra             # PART 2: Run this second
    ├── providers.tf          # Contains the 'backend "s3"' block
    ├── Ec2.tf                # Spot instance and SG logic
    ├── local_key.pub         # Your public key
    └── output.tf             # Jenkins IP address

```

---

### Updated README.md

```markdown
# AWS Jenkins Infrastructure with Remote State

This repository contains Terraform code to deploy a Jenkins server on AWS using Spot instances, with a secure remote backend for state management.

## 📁 Project Structure

1.  **`backend-bootstrap/`**: Infrastructure for Terraform state storage (S3 & DynamoDB).
2.  **`jenkins-infra/`**: The core Jenkins server setup on EC2.

---

## 🛠️ Execution Order

### 1. Provision the Remote Backend
Navigate to `/backend-bootstrap`. This creates the "home" for your state files.

```bash
cd backend-bootstrap
terraform init
terraform apply

```

**Resources created:**

* S3 Bucket: `jenkins-state-demo-1234`
* DynamoDB Table: `jenkins-state-lock-table`

### 2. Provision the Jenkins Server

Navigate to `/jenkins-infra`. This project is configured to store its state in the resources created in Step 1.

```bash
cd ../jenkins-infra
terraform init  # This will connect to the S3 bucket
terraform apply

```

**Resources created:**

* EC2 Spot Instance (`t3.xlarge`)
* 20GB gp3 Root Volume
* Security Group (All Traffic)
* Key Pair for SSH access

---

## 🔗 Backend Configuration

The `jenkins-infra` project uses the following backend block in `providers.tf`:

```hcl
terraform {
  backend "s3" {
    bucket         = "jenkins-state-demo-1234"
    key            = "jenkins/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "jenkins-state-lock-table"
    encrypt        = true
    profile        = "terraform-user"
  }
}

```

## 🔒 Security & Maintenance

* **State Locking:** DynamoDB ensures that only one person can modify the infrastructure at a time.
* **Cost Optimization:** Using **Spot Instances** saves up to 90% compared to On-Demand pricing.
* **Isolation:** The storage (Backend) and compute (Jenkins) are managed separately for better stability.

```

Would you like me to help you create the **`outputs.tf`** file for the `backend-bootstrap` folder so you can easily copy the names into your main project?

```