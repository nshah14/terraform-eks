data "aws_subnet" "cluster-subnet" {
  id = "${var.subnet_id}"
}
resource "aws_security_group" "eks-cluster" {
  name        = "terraform-eks-cluster"
  description = "Cluster communication with worker nodes"
  #vpc_id      = var.vpc_id #(need to be replaced by the vpc id from variables)
  vpc_id = "${data.aws_subnet.cluster-subnet.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-eks-cluster"
  }
}

resource "aws_security_group_rule" "eks-cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks-cluster.id
  source_security_group_id = aws_security_group.worker-node.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-cluster-ingress-workstation-https" {
 
  cidr_blocks       = [local.workstation-external-cidr]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.eks-cluster.id
  to_port           = 443
  type              = "ingress"
}

