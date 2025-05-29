provider "aws" {
 region = "ap-south-1"
  # access_key = ""
  # secret_key = ""
}

resource "aws_instance" "admin" {
  ami = "ami-0e35ddab05955cf57"
  instance_type = "t2.medium"
  security_groups = ["default"]
  key_name = "windows"
  root_block_device {
    
    volume_size = 20
    volume_type = "gp2"
    delete_on_termination = true
  }
  tags = {
    Name ="Admin-Server"
  }
  user_data = <<-EOF
  #!/bin/bash
  sudo snap install microk8s --classic
  alias kubectl='microk8s kubectl'
  EOF
}

output "PublicIP" {
  value = aws_instance.admin.public_ip  
}