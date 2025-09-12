A target group is where the ALB sends traffic.
Here, any request to the frontend ALB is forwarded to EC2 instances registered in this group.
health_check ensures that only healthy instances (returning HTTP 200 on /) receive traffic.

Creates an Application Load Balancer (ALB) for the frontend.
internal = false → means it’s public-facing (accessible from the internet).
Placed in public subnets.
Attached to a security group for firewall rules.

A listener listens for incoming traffic on a port.
Here:
Listens on HTTP port 80.
Forwards all requests to the frontend target group.

Same concept as frontend, but for backend EC2 instances.
Used by the backend ALB to forward traffic.

Creates another ALB for backend services.
Also public-facing (internal = false), which may not be ideal for backend — usually backend ALBs should be internal (internal = true) so only frontend services can access them.

Listens on port 80.
Forwards traffic to the backend target group.

Frontend ALB:

Public-facing, listens on port 80.
Forwards requests to frontend instances (via frontend target group).

Backend ALB:

Also public-facing (but best practice is to make it internal).
Forwards requests to backend instances (via backend target group).
