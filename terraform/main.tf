data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
    Workspace   = terraform.workspace
  }
}

resource "aws_instance" "app" {
  count = var.instance_count

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  # Dev (count=1) gets index 0 % 3 = 0. Prod (count=3) gets 0, 1, 2.
  subnet_id = aws_subnet.public[count.index % 3].id

  key_name = aws_key_pair.kp.key_name

  vpc_security_group_ids = [aws_security_group.ec2.id]

  associate_public_ip_address = true

  user_data = <<-EOF
#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a
export NEEDRESTART_SUSPEND=1
until apt-get update -y && apt-get install -y python3-flask; do
  echo "Waiting for apt lock..."
  sleep 5
done

mkdir -p /app/templates

cat << 'PYTHON_EOF' > /app/app.py
${file("${path.module}/../app.py")}
PYTHON_EOF

cat << 'HTML_EOF' > /app/templates/dashboard.html
${file("${path.module}/../templates/dashboard.html")}
HTML_EOF

cd /app
export ENVIRONMENT=${var.environment}
export APP_PORT=${var.app_port}
nohup python3 app.py > app.log 2>&1 &
EOF

  user_data_replace_on_change = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${terraform.workspace}-server-${count.index + 1}"
  })
}
