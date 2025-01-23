# --------------------------------------------
# -----Create CRM Prod app---------------------
# --------------------------------------------

resource "aws_instance" "crm-web01-stg" {
  ami                    = data.aws_ami.amazon-linux.id
  instance_type          = var.instance_type
  availability_zone      = aws_subnet.staging_subnet.availability_zone
  subnet_id              = aws_subnet.staging_subnet.id
  vpc_security_group_ids = [aws_security_group.stagewebsg.id]
  private_ip = "10.10.4.41"
  tags = {
    Name  = "crm-web01-stg"
    Env = "staging"
    Role = "web"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y httpd
    sudo systemctl start httpd
    sudo systemct enable httpd
    sudo yum install telnet -y
    sudo yum install cronie -y
    sudo systemctl enable crond.service
    sudo systemctl start crond.service
    sudo yum install nc -y
    (crontab -l 2>/dev/null || echo ""; echo "* * * * *  telnet 10.10.4.42 5000 -t 10 >> /tmp/DB.log") | crontab -
    (crontab -l 2>/dev/null || echo ""; echo "* * * * *  telnet 10.0.2.21 443 -t 10 >> /tmp/DB.log") | crontab -
  EOF
}

resource "aws_instance" "crm-proc01-stg" {
  ami                    = data.aws_ami.amazon-linux.id
  instance_type          = var.instance_type
  availability_zone      = aws_subnet.staging_subnet.availability_zone
  subnet_id              = aws_subnet.staging_subnet.id
  vpc_security_group_ids = [aws_security_group.stageprocsg.id]
  private_ip = "10.10.4.42"
  tags = {
    Name  = "crm-proc01-stg"
    Env = "staging"
    Role = "proc"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y httpd
    sudo systemctl start httpd
    sudo systemct enable httpd
    sudo yum install telnet -y
    sudo yum install cronie -y
    sudo systemctl enable crond.service
    sudo systemctl start crond.service
    sudo yum install nc -y
    while true; do nc -l -p 5000; done &
    (crontab -l 2>/dev/null || echo ""; echo "* * * * *  telnet 10.10.4.43 3306 -t 10 >> /tmp/DB.log") | crontab -
  EOF
}

resource "aws_instance" "crm-db01-stg" {
  ami                    = data.aws_ami.amazon-linux.id
  instance_type          = var.instance_type
  availability_zone      = aws_subnet.staging_subnet.availability_zone
  subnet_id              = aws_subnet.staging_subnet.id
  vpc_security_group_ids = [aws_security_group.stagedbsg.id]
  private_ip = "10.10.4.43"
  tags = {
    Name  = "crm-db01-prd"
    Env = "staging"
    Role = "db"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y httpd
    sudo systemctl start httpd
    sudo systemct enable httpd
    sudo yum install telnet -y
    sudo yum install cronie -y
    sudo systemctl enable crond.service
    sudo systemctl start crond.service
    sudo yum install nc -y
    while true; do nc -l -p 3306; done &
  EOF
}