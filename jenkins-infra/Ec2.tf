# Create a key pair for local access
resource "aws_key_pair" "window_local_key" {
  key_name   = "local_key"
  public_key = file("local_key.pub")
}

# Use the default VPC 
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}


# Create a security group
resource "aws_security_group" "jenkins_sg" {
  name        = "Jenkins-SG"
  description = "Allow all inbound traffic"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description      = "Allow SSH from everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]  # From any IP address
    }


  ingress {
    description      = "Allow ALL traffic from everywhere"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"           # "-1" means all protocols/all ports
    cidr_blocks      = ["0.0.0.0/0"]  # From any IP address
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }



}

# Create a Ec2 instance in the default VPC with the security group and key pair

resource "aws_instance" "jenkins" {
  ami                         = "ami-0ecb62995f68bb549"  # ubuntu ami  in us-east-1
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.window_local_key.key_name
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  #user_data = file("miniKube.sh")

  tags = {
    Name = "Jenkins-Server"
  }

# --- SPOT INSTANCE CONFIGURATION ---
instance_market_options {
    market_type = "spot"
    spot_options {
      spot_instance_type = "persistent"
      instance_interruption_behavior = "stop" # This preserves the disk!
    }
  }

    # --- VOLUME CONFIGURATION ---
  root_block_device {
    volume_size           = 40
    volume_type           = "gp3" # Latest General Purpose SSD
    delete_on_termination = true
  }


}


