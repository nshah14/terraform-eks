data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.test.version}-v*"]
  }

  most_recent = true
  owners      = [var.owner] # Accout id
}


locals {
  worker-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.test.endpoint}' --b64-cluster-ca '${aws_eks_cluster.test.certificate_authority[0].data}' '${var.cluster-name}'
USERDATA

}

resource "aws_launch_configuration" "worker" {
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.worker-node.name
  image_id = data.aws_ami.eks-worker.id
  instance_type = "t2.large"
  name_prefix = "terraform-eks-worker"
  security_groups = [aws_security_group.worker-node.id]
  user_data_base64 = base64encode(local.worker-node-userdata)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "worker" {
  desired_capacity = 2
  launch_configuration = aws_launch_configuration.worker.id
  max_size = 2
  min_size = 1
  name = "terraform-eks-worker"
  vpc_zone_identifier  = ["${data.aws_subnet.subnet-gCoK8S.id}"]
  
  tag {
    key = "Name"
    value = "terraform-eks-worker"
    propagate_at_launch = true
  }

  tag {
    key = "kubernetes.io/cluster/${var.cluster-name}"
    value = "owned"
    propagate_at_launch = true
  }
}

