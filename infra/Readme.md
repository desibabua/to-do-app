<!-- ayushEKSClusterRole -->


I am role 
 - one for eks cluster


vpc - (default) and subnets (default) (2 public and 2 private)

security group
- inbound (HTTP and SSH)
- outbound (public 0.0.0.0/0)

cluster - 
- iam role
- vpc, subnets
- security group

<!-- namespace
- for cluster -->

I am role 
 - second for node group

node group
- I am role
- three policy
- 2 nodes
- t2.micro

----------

deployed the image

create service of type load Balancer on the above deployment