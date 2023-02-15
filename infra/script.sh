#!/bin/bash

# terraform apply
aws eks update-kubeconfig --region ap-south-1 --name ayush_infra_eks_cluster
kubectl get nodes

# echo "-----------running deployment in cluster"
# kubectl apply -f k8s/deployment.yml

# echo "----------- add load balancer"
# kubectl expose deployment to-do-app-deployment --type=LoadBalancer
kubectl describe service/to-do-app-deployment