# Amazon EKS IAM Setup (CloudFormation)

```yaml

AWSTemplateFormatVersion: "2010-09-09"
Description: >
  IAM setup for Amazon EKS:
  - IAM User
  - EKS Deployer Role (Terraform)
  - EKS Cluster Role
  - EKS Node Role
  - EKS Admin Role (kubectl)

Parameters:
  EksUserName:
    Type: String
    Default: eks-deployer-user
    Description: IAM user who deploys EKS using Terraform

Resources:

  ######################################
  # IAM USER (NO PERMISSIONS)
  ######################################
  EksDeployerUser:
    Type: AWS::IAM::User
    Properties:
      UserName: !Ref EksUserName

  ######################################
  # EKS CLUSTER ROLE (CONTROL PLANE)
  ######################################
  EKSClusterRole:
    Type: AWS::IAM::Role
    Properties:
      RoleName: eks-cluster-role
      AssumeRolePolicyDocument:
        Version: "2012-10-17"
        Statement:
          - Effect: Allow
            Principal:
              Service: eks.amazonaws.com
            Action: sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/AmazonEKSClusterPolicy

  ######################################
  # EKS NODE ROLE (WORKER NODES)
  ######################################
  EKSNodeRole:
    Type: AWS::IAM::Role
    Properties:
      RoleName: eks-node-role
      AssumeRolePolicyDocument:
        Version: "2012-10-17"
        Statement:
          - Effect: Allow
            Principal:
              Service: ec2.amazonaws.com
            Action: sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy
        - arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly
        - arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy

  ######################################
  # EKS DEPLOYER ROLE (TERRAFORM)
  ######################################
  EKSDeployerRole:
    Type: AWS::IAM::Role
    Properties:
      RoleName: eks-deployer-role
      AssumeRolePolicyDocument:
        Version: "2012-10-17"
        Statement:
          - Effect: Allow
            Principal:
              AWS: !GetAtt EksDeployerUser.Arn
            Action: sts:AssumeRole

  ######################################
  # EKS DEPLOYER POLICY (INFRA ONLY)
  ######################################
  EKSDeployerPolicy:
    Type: AWS::IAM::Policy
    Properties:
      PolicyName: eks-deployer-policy
      Roles:
        - !Ref EKSDeployerRole
      PolicyDocument:
        Version: "2012-10-17"
        Statement:

          # ---- EKS ----
          - Effect: Allow
            Action:
              - eks:CreateCluster
              - eks:DeleteCluster
              - eks:DescribeCluster
              - eks:UpdateClusterConfig
              - eks:CreateNodegroup
              - eks:DeleteNodegroup
              - eks:DescribeNodegroup
              - eks:UpdateNodegroupConfig
              - eks:List*
              - eks:CreateAccessEntry
              - eks:AssociateAccessPolicy
            Resource: "*"

          # ---- EC2 / NETWORKING ----
          - Effect: Allow
            Action:
              - ec2:Describe*
              - ec2:CreateSecurityGroup
              - ec2:DeleteSecurityGroup
              - ec2:AuthorizeSecurityGroupIngress
              - ec2:RevokeSecurityGroupIngress
              - ec2:CreateTags
            Resource: "*"

          # ---- AUTOSCALING ----
          - Effect: Allow
            Action:
              - autoscaling:CreateAutoScalingGroup
              - autoscaling:DeleteAutoScalingGroup
              - autoscaling:UpdateAutoScalingGroup
              - autoscaling:Describe*
            Resource: "*"

          # ---- CLOUDWATCH LOGS ----
          - Effect: Allow
            Action:
              - logs:CreateLogGroup
              - logs:DescribeLogGroups
              - logs:PutRetentionPolicy
            Resource: "*"

          # ---- IAM (FOR TERRAFORM) ----
          - Effect: Allow
            Action:
              - iam:CreateRole
              - iam:DeleteRole
              - iam:AttachRolePolicy
              - iam:DetachRolePolicy
              - iam:GetRole
              - iam:ListRoles
            Resource: "*"

          # ---- PASS ROLE (LOCKED) ----
          - Effect: Allow
            Action: iam:PassRole
            Resource:
              - !GetAtt EKSClusterRole.Arn
              - !GetAtt EKSNodeRole.Arn

  ######################################
  # USER -> ASSUME DEPLOYER ROLE
  ######################################
  AllowUserToAssumeDeployerRole:
    Type: AWS::IAM::Policy
    Properties:
      PolicyName: allow-assume-eks-deployer-role
      Users:
        - !Ref EksDeployerUser
      PolicyDocument:
        Version: "2012-10-17"
        Statement:
          - Effect: Allow
            Action: sts:AssumeRole
            Resource: !GetAtt EKSDeployerRole.Arn

  ######################################
  # EKS ADMIN ROLE (kubectl access)
  ######################################
  EKSAdminRole:
    Type: AWS::IAM::Role
    Properties:
      RoleName: eks-admin-role
      AssumeRolePolicyDocument:
        Version: "2012-10-17"
        Statement:
          - Effect: Allow
            Principal:
              AWS: !GetAtt EksDeployerUser.Arn
            Action: sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/AmazonEKSAdminPolicy

Outputs:
  DeployerUser:
    Value: !Ref EksDeployerUser
    Description: IAM user for EKS deployment

  DeployerRoleArn:
    Value: !GetAtt EKSDeployerRole.Arn
    Description: Terraform assumes this role to create EKS

  AdminRoleArn:
    Value: !GetAtt EKSAdminRole.Arn
    Description: Role used for kubectl access

 

```

# 

## **Overview**

This CloudFormation template sets up **IAM roles and policies** required for deploying and managing an Amazon EKS cluster using an **existing IAM user**.

It includes:

- EKS Cluster Role (control plane)
- EKS Node Role (worker nodes)
- EKS Deployer Role (Terraform user)
- EKS Deployer Policy (Terraform permissions)
- User permission to assume the deployer role
- EKS Admin Role (kubectl access)

> **Note:** This template does **not create a new IAM user**. You must provide the ARN of an existing IAM user.
> 

---

## **Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `ExistingEksUserArn` | String | ARN of the existing IAM user who will deploy EKS using Terraform |

---

## **Resources**

### **1. EKS Cluster Role (Control Plane)**

- **Resource Name:** `EKSClusterRole`
- **Purpose:** Role assumed by the **EKS control plane**.
- **Permissions:** `AmazonEKSClusterPolicy` managed policy.
- **Trust Policy:** Trusted by `eks.amazonaws.com` (EKS service).

```yaml
Principal:Service:eks.amazonaws.com
```

---

### **2. EKS Node Role (Worker Nodes)**

- **Resource Name:** `EKSNodeRole`
- **Purpose:** Role assumed by EC2 worker nodes in the EKS cluster.
- **Permissions:**
    - `AmazonEKSWorkerNodePolicy`
    - `AmazonEC2ContainerRegistryReadOnly`
    - `AmazonEKS_CNI_Policy`
- **Trust Policy:** Trusted by `ec2.amazonaws.com` (EC2 service).

```yaml
Principal:Service:ec2.amazonaws.com
```

---

### **3. EKS Deployer Role (Terraform) - (ClusterAdminRole)**

- **Resource Name:** `EKSDeployerRole`
- **Purpose:** Role assumed by the existing IAM user for **Terraform deployments**.
- **Trust Policy:** Allows the **existing IAM user** to assume this role.

```yaml
Principal:AWS:!RefExistingEksUserArn
```

---

### **4. EKS Deployer Policy (Terraform Permissions)**

- **Resource Name:** `EKSDeployerPolicy`
- **Purpose:** Grants the deployer role **permissions required to create and manage EKS infrastructure**.

**Key Permissions:**

| Service | Actions |
| --- | --- |
| **EKS** | `CreateCluster`, `DeleteCluster`, `DescribeCluster`, `UpdateClusterConfig`, `CreateNodegroup`, `DeleteNodegroup`, `DescribeNodegroup`, `UpdateNodegroupConfig`, `List*`, `CreateAccessEntry`, `AssociateAccessPolicy` |
| **EC2 / Networking** | `Describe*`, `CreateSecurityGroup`, `DeleteSecurityGroup`, `AuthorizeSecurityGroupIngress`, `RevokeSecurityGroupIngress`, `CreateTags` |
| **AutoScaling** | `CreateAutoScalingGroup`, `DeleteAutoScalingGroup`, `UpdateAutoScalingGroup`, `Describe*` |
| **CloudWatch Logs** | `CreateLogGroup`, `DescribeLogGroups`, `PutRetentionPolicy` |
| **IAM** | `CreateRole`, `DeleteRole`, `AttachRolePolicy`, `DetachRolePolicy`, `GetRole`, `ListRoles` |
| **Pass Role** | Allows passing `EKSClusterRole` and `EKSNodeRole` for Terraform deployment |

---

### **5. Allow Existing User to Assume Deployer Role**

- **Resource Name:** `AllowUserToAssumeDeployerRole`
- **Purpose:** Grants the **existing IAM user permission to call `sts:AssumeRole`** on `EKSDeployerRole`.
- **Why needed:** Both the role’s trust policy and the user’s permission must exist to assume a role successfully.

```yaml
Action:sts:AssumeRoleResource:!GetAttEKSDeployerRole.Arn
```

---

### **6. EKS Admin Role (kubectl access)**

- **Resource Name:** `EKSAdminRole`
- **Purpose:** Allows the **existing IAM user** to assume an admin role for **kubectl access**.
- **Permissions:** `AmazonEKSAdminPolicy` managed policy
- **Trust Policy:** Allows multiple users (if needed) to assume this role.

```yaml
Principal:AWS:!RefExistingEksUserArn
```

> **Tip:** To allow multiple users, `AWS` can be a **list of ARNs**.
> 

---

## **Outputs**

| Name | Value | Description |
| --- | --- | --- |
| `DeployerRoleArn` | `!GetAtt EKSDeployerRole.Arn` | ARN of the role that Terraform assumes to create EKS |
| `AdminRoleArn` | `!GetAtt EKSAdminRole.Arn` | ARN of the role used for kubectl access |

---

## **How It Works**

1. **Existing IAM user** assumes the **EKSDeployerRole** to deploy the EKS cluster using Terraform.
2. **Terraform** creates:
    - EKS Cluster (control plane)
    - Node groups (worker nodes)
3. IAM roles for **control plane and nodes** are automatically created and assigned policies.
4. User can assume **EKSAdminRole** for kubectl access to manage cluster resources.

---

##
