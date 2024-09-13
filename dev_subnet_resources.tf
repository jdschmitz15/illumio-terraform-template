# --------------------------------------------
# -----Create Point-of-sale Dev app----------
# --------------------------------------------
resource "aws_instance" "pos-web01-dev" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  availability_zone      = aws_subnet.dev_subnet.availability_zone
  subnet_id              = aws_subnet.dev_subnet.id
  vpc_security_group_ids = [aws_security_group.devwebsg.id]
  key_name = "CloudsecureFreeTrial"
  private_ip = "10.0.3.21"
  tags = {
    Name  = "pos-web01-dev"
    Env = "dev"
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
    (crontab -l 2>/dev/null || echo ""; echo "* * * * *  telnet 10.0.3.22 5000 -t 10 >> /tmp/DB.log") | crontab -
  EOF
}

resource "aws_instance" "pos-proc01-dev" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  availability_zone      = aws_subnet.dev_subnet.availability_zone
  subnet_id              = aws_subnet.dev_subnet.id
  vpc_security_group_ids = [aws_security_group.devprocsg.id]
  key_name = "CloudsecureFreeTrial"
  private_ip = "10.0.3.22"
  tags = {
    Name  = "pos-web01-dev"
    Env = "dev"
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
    (crontab -l 2>/dev/null || echo ""; echo "* * * * *  telnet 10.0.3.23 3306 -t 10 >> /tmp/DB.log") | crontab -
  EOF
}

resource "aws_instance" "pos-db01-dev" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  availability_zone      = aws_subnet.dev_subnet.availability_zone
  subnet_id              = aws_subnet.dev_subnet.id
  vpc_security_group_ids = [aws_security_group.devdbsg.id]
  key_name = "CloudsecureFreeTrial"
  private_ip = "10.0.3.23"
  tags = {
    Name  = "pos-db01-dev"
    Env = "dev"
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
    while true; do nc -l -p 3306; done &
    (crontab -l 2>/dev/null || echo ""; echo "* * * * *  telnet 10.0.2.23 3306 -t 10 >> /tmp/DB.log") | crontab -
  EOF
}

# --------------------------------------------
# -----Create HR Dev app---------------------
# --------------------------------------------

resource "aws_instance" "hr-web01-dev" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  availability_zone      = aws_subnet.dev_subnet.availability_zone
  subnet_id              = aws_subnet.dev_subnet.id
  vpc_security_group_ids = [aws_security_group.devwebsg.id]
  key_name = "CloudsecureFreeTrial"
  private_ip = "10.0.3.31"
  tags = {
    Name  = "hr-web01-dev"
    Env = "dev"
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
    (crontab -l 2>/dev/null || echo ""; echo "* * * * *  telnet 10.0.3.32 5000 -t 10 >> /tmp/DB.log") | crontab -
    (crontab -l 2>/dev/null || echo ""; echo "* * * * *  telnet 10.0.2.33 3306 -t 10 >> /tmp/DB.log") | crontab -
  EOF
}

resource "aws_instance" "hr-proc01-dev" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  availability_zone      = aws_subnet.dev_subnet.availability_zone
  subnet_id              = aws_subnet.dev_subnet.id
  vpc_security_group_ids = [aws_security_group.devprocsg.id]
  key_name = "CloudsecureFreeTrial"
  private_ip = "10.0.3.32"
  tags = {
    Name  = "hr-proc01-dev"
    Env = "dev"
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
    (crontab -l 2>/dev/null || echo ""; echo "* * * * *  telnet 10.0.3.33 3306 -t 10 >> /tmp/DB.log") | crontab -
  EOF
}

resource "aws_instance" "hr-db01-dev" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  availability_zone      = aws_subnet.dev_subnet.availability_zone
  subnet_id              = aws_subnet.dev_subnet.id
  vpc_security_group_ids = [aws_security_group.devdbsg.id]
  key_name = "CloudsecureFreeTrial"
  private_ip = "10.0.3.33"
  tags = {
    Name  = "hr-db01-dev"
    Env = "dev"
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
