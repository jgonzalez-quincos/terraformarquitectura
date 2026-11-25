# Global Variables
aws_region="us-east-1"
my_ip="200.122.208.2/32"
profile="PSeminario"

# Network Variables
vpc_cidr="172.20.0.0/23"
pub_subnets=["172.20.0.0/26", "172.20.0.64/26"]
priv_subnets=["172.20.0.128/26", "172.20.0.192/26"]

# Compute Variables
key_name="kp-lab-ps"
master_type="t3.medium"
worker_type="t3.large"