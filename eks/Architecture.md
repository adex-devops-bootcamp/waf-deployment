# EKS Cluster Architecture


![alt text](./images/eksclusterarch.drawio.svg)

---

## Knowledge so far

---
### Quick Recap 

- Role: AWS Identity with short term credential assumed by service, user or and external identity ( like OIDC )
- Trust policy: States who can assume role
- Permission policy: Gives actual permission to the role

---

### Requirements 

- **ClusterRole:** 
    - assumed by control plane

- **NodeRole:**  
    - assumed by worker nodes

- **ClusterAminRole** 
    - assumed by user who manages EKS cluster ( for terraform )
    - can create and manage EKS cluster
    - can create and manage all required resources for EKS cluster
    - can add other roles or users to access entry and associate EKSAdminPolicy 

- **EKSAdminRole:** 
    - assumed by users who need kubectl access ( for all of us,  once cluster setup completes)
---