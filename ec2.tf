resource "aws_instance" "web" {
  ami           = "ami-0f3c7d07486cad139" #devops-practice
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.roboshop-all.id]

  tags = {
    Name = "provisioners"
  }

   provisioner "local-exec" {
    command = "echo send alert during the creation time of to systems like email and alerts"
  }

   provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip} > inventory"
  }

#    provisioner "local-exec" {
#     command = "ansible-playbook -i inventory web.yaml"
#     on_failure = continue
#   }

  provisioner "local-exec" {
    command = "echo send alert during the destroy time of to systems like email and alerts"
    when = destroy
  }

  connection {
    type     = "ssh"
    user     = "centos"
    password = "DevOps321"
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'print message hello' > /tmp/remote.txt",
      "sudo yum install nginx -y",
      "sudo systemctl start nginx",
      "sudo systemctl status nginx"
      
    ]
  }  

}



resource "aws_security_group" "roboshop-all" { # this is terraform name for  terraform reference only
  name        = "roboshop-all" # This is for AWS
  description = "Allow all ports"
  #vpc_id      = aws_vpc.main.id

   ingress {
    description      = "Allow all ports"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

   ingress {
    description      = "Allow all ports"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "roboshop-all-aws"
  }
}
