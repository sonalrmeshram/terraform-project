VPC Creation
resource "aws_vpc" "project" { ... }
Creates a Virtual Private Cloud with a CIDR block (var.vpc_cidr_block).
enable_dns_hostnames = true → allows EC2 instances to get DNS hostnames.
enable_dns_support = true → allows DNS resolution in VPC.
✅ This is the backbone of your AWS network.

These subnets are internet-facing.
Used for:
Bastion host
Public Load Balancers
Placed in different AZs for high availability.

Internet Gateway (IGW) allows public subnet resources to access the internet.
Public route table routes 0.0.0.0/0 traffic to the IGW.
Route table associations attach public subnets to this table.

EC2 in public subnet with public IP.
Used to SSH into private instances.

Backend, frontend apps, and RDS live here.
Not directly reachable from the internet.

NAT in a public subnet with an Elastic IP.
Allows private instances to access the internet (for updates, packages, etc.) without exposing them to public.

Routes 0.0.0.0/0 traffic from private subnets to the NAT gateway.
Ensures private instances can reach the internet safely.

✅ How It All Works Together
Layer	Subnet Type	Access
Bastion Host	Public	Internet (SSH)
Frontend ALB	Public	Internet (HTTP/HTTPS)
Frontend App	Private	NAT for internet, access backend/RDS
Backend App	Private	NAT for internet, access RDS
RDS	Private	Only backend app

Public subnets → Internet-facing resources (ALB, Bastion).

Private subnets → Internal resources (apps, RDS).

NAT → Private instances reach internet, but remain hidden.

Route tables → Control traffic flow between subnets and internet.
