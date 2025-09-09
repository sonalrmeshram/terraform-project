Fetches the most recent AMI you own matching the name in var.frontend_ami.
This ensures your instances always use the latest frontend image.

image_id → from the AMI above.
instance_type → t2.micro.
vpc_security_group_ids → which SG to use.
key_name → SSH key.
Tags → for naming instances.
lifecycle { create_before_destroy = true } → ensures smooth updates during changes.

Automatically manages number of frontend instances.
Key attributes:
vpc_zone_identifier → private subnets for frontend EC2.
target_group_arns → attaches instances to the frontend ALB.
min_size, max_size, desired_capacity → scaling configuration.
instance_refresh → rolling updates strategy (keeps at least 50% healthy).
depends_on → ensures backend ASG exists before frontend updates.

Target Tracking Scaling Policy based on CPU utilization.
Example: If average CPU exceeds var.scale_out_target_value, ASG adds new instances automatically.

Backend AMI, Launch Template, ASG, and Scaling Policy
Works exactly like frontend, but for backend:
Uses backend AMI.
Launches instances in private subnets.
Attached to backend ALB.
Has its own auto scaling policy.

User → Frontend ALB → forwards to frontend instances (ASG).
Frontend instance → calls Backend ALB → forwards to backend instances (ASG).
Backend instance → queries RDS.
ASG ensures scaling automatically based on CPU.

Make sure frontend can access backend ALB:
If backend ALB is internal, frontend EC2 must be in the same VPC and security groups allow it.
Use different SGs for frontend & backend, and allow only necessary traffic:
Frontend SG → inbound from internet (ALB), outbound to backend SG.
Backend SG → inbound from frontend SG, outbound to RDS.
Private subnets are good for backend and RDS; public subnets for frontend if needed.
  
