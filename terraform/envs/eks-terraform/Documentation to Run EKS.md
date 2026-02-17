# Documentation to Run EKS

# STEP 1 — Run `eks-iam.yaml`

This workflow should create:

- IAM User → `terraform-user`
- IAM policies for EKS
- Access keys for Terraform-user
- Possibly roles like:
    - EKS Cluster Role
    - EKS Node Role

These are required before Terraform runs.

---

## 🔹 How to Run `eks-iam.yaml`

1. Go to **GitHub Repo**
2. Go to **Actions**
3. Select workflow →  `eks-iam.yaml`
4. Click **Run workflow**

After success:

---

## 🔹 Verify in AWS Console

Go to:

👉 **Amazon Web Services Console**

👉 IAM → Users

You should see:

- `terraform-user`

Check:

- Security Credentials → Access Keys
- Policies attached (should allow EKS, EC2, VPC, IAM, etc.)

---

# ✅ STEP 2 — Add Terraform User Keys to GitHub Secrets

Now take the access key + secret key of `terraform-user`  . Search “Parameter store” then get the keys from Parameter store       

Go to:

GitHub Repo → Settings → Secrets → Actions

Add:

```
TERRAFORM_USER_ACCESS_KEY_ID
TERRAFORM_USER_SECRET_ACCESS_KEY
```

⚠️ These are different from `AWS_ACCESS_KEY_ID` used for bootstrap.

Also add these in local in  ~/.aws/credentials

```
[terraform-user]
ACCESS_KEY_ID=******************
SECRET_ACCESS_KEY=******************
```

This is required for to update kubeconfig file

---

# ✅ STEP 3 — Run EKS Infrastructure Workflow (Terraform)

Now run your second workflow:

`EKS Infrastructure (Terraform)`

This does:

- VPC creation
- Subnets
- Internet Gateway
- EKS Cluster
- Node Group

---

## 🔹 How to Run

Go to:

GitHub → Actions →

Select **EKS Infrastructure (Terraform)**

Click **Run workflow**

You can use default inputs for ease.

---

## 🔹 What Happens Internally

Terraform will:

1. Create VPC
2. Create Subnets
3. Create Security Groups
4. Create EKS Cluster
5. Create Node Group

Resources you will see in AWS:

- VPC → EC2 section
- EKS → Clusters

Go to:

👉 **Amazon Elastic Kubernetes Service**

Check cluster: `learning-eks`

Wait until:

```
Clusterstatus: ACTIVE
Node groupstatus: ACTIVE
```

---

# ✅ STEP 4 — Configure kubectl (Local Machine)

Now from your **local machine** (NOT GitHub Actions), run:

```bash
aws eks update-kubeconfig \
  --region us-east-1 \
  --name learning-eks \
  --profile terraform-user
```

This will:

- Update `~/.kube/config`
- Add cluster authentication config

---

# ✅ STEP 5 — Verify Nodes

Now run:

```bash
kubectl get nodes
```

Expected output:

```
ip-10-0-x-x.ec2.internal   Ready   <role>   ...
```

If working, you have successfully:

✔ Created IAM

✔ Created VPC

✔ Created EKS

✔ Created Node Group

✔ Connected kubectl

---

# 🔎 If `kubectl get nodes` Fails

Check:

1. Is cluster ACTIVE?
2. Is node group ACTIVE?
3. Is your IAM user mapped in aws-auth?
4. Does your local AWS CLI use correct credentials?

---

# 🧠 Complete Flow Summary

```
1️⃣ eks-iam.yaml → Create terraform-user + roles
2️⃣ Add terraform-user keys to GitHub secrets
3️⃣ Run EKS Infrastructure workflow
4️⃣ Waituntilcluster ACTIVE
5️⃣ aws eksupdate-kubeconfig
6️⃣ kubectl get nodes
```