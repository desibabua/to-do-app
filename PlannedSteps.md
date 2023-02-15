—————Plan —————

STEP 1:-

- [x] Setup Github accounts/ collaboration techniques.
- [x] Create docker  Image. Push it to our personal docker registry.
- [x] Push it to collaborated account.
- [x] Test - pull the image and check running fine.

Tech Stack :-
- [x] Docker + colima

STEP 2 :-
- [x] Set up initial yaml for Kubernetes with correct no of pods and kind.
- [x] Run it Kubernetes cluster in our local.
- [x] Test - hosting working fine in local, with now downtime when new version or any changes applied

Tech Stack :-
- [x] Kubernetes

STEP 3:-
- [x] Create EKS cluster, security groups, vpc and I’m roles manually through AWS management tool.
- [x] Create security group , vpc through Yaml
- [x] Create IAM role and provide 
- [x] create EKS cluster and run the application in that.
- [x] Testing - running EKS cluster with added test for terraform files.

Tech Stack :-
- [x] Terraform 
- [x] Aws

STEP 4:-
- [ ] Create initial workflow with install, test and build
- [ ] Create image and push to docker registry
- [ ] Create cluster and run the docker image
- [ ] Test - It should correctly deploy through action after every commit.

Tech Stack :-
- [ ] Git hub action

