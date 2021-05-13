resource "aws_instance" "ec2_instance" {
  ami           = var.provide_ami
  instance_type = var.instance_type
  
  key_name = var.key_name
#  cpu_core_count = 4
#  cpu_threads_per_core = 2
#  availability_zone = var.availability_zone[0]
  monitoring = true
  security_groups = [var.provide_security_group]
  subnet_id = var.subnet_id
  associate_public_ip_address = true
  root_block_device {
    volume_type = "gp2"
    volume_size = 20
    delete_on_termination = true
    encrypted = true
    kms_key_id = "d4faa181-32bd-48f4-987f-3fb9160caec7"
  }
  ebs_block_device {
    device_name = "/dev/xvdb"
    volume_type = "gp2"
    volume_size = 30
    delete_on_termination = true
    encrypted = true
    kms_key_id = "d4faa181-32bd-48f4-987f-3fb9160caec7"
  }
  user_data =   <<-EOF
                #!/bin/bash
                /usr/sbin/useradd -s /bin/bash -m ritesh;
                mkdir /home/ritesh/.ssh;
                chmod -R 700 /home/ritesh;
                echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJlKY/Wv7MMhv0sMnkQ863LyOUn9sptj/H3lU2w3Dos/KkoLUVqvGLIT6wF0muuZkJp4F0/kkvgwS6upfghdIUmqsNhlIGvczLF9+Ht4tR5YD12pw9zN4NcikT667VqKJeVM83NLeOX8imgca2rbUjSUOO2sjgLJa60/PQkcKiMFAfbMYkE2tYTQCW5s3AfoJB/7wPg/X+bcLwGJjTwwGtXF5NcgJ0um8qCdoXzD6dMeApJeUq73qez9oqz9c+p9VoPkWgxV+A5OyNup1ydCxqte7eJGt6ay0/fTtm4nT9j0GAnnaH31kt9V6W4xJxKRjW2syJ6KJpBXmt4ZLnDbGq8nTDN/7z6dMWR7Ai2pAGgYcMZcizVK8wx5GG9C4+kQR1nRVVqhB1bdWJjXVIUGnry826qnrtImJyFvtrAuFQXsnC2noBp+0aCLeFNT9TtxDwZLGJ33xgrPcVvCyxL8rlUyxrIMH8CGXRXAIgDRv3Nu0CTp6q8IkCNt+ZzGC6//U= ritesh@DESKTOP-2UQTKO7" >> /home/ritesh/.ssh/authorized_keys;
                chmod 600 /home/ritesh/.ssh/authorized_keys;
                chown ritesh:ritesh /home/ritesh/.ssh -R;
                echo "ritesh  ALL=(ALL)  NOPASSWD: ALL" > /etc/sudoers.d/ritesh;
                chmod 440 /etc/sudoers.d/ritesh;
                sudo yum update -y
                sudo yum install -y httpd
                sudo systemctl start httpd
                sudo systemctl enable httpd
                echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
                EOF
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = var.instance_name
  }
  lifecycle {
    prevent_destroy = true    # can't destroy resource after its creation
    ignore_changes = [ ami ]  # can't change ami after creation of resource
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  acl    = var.access_control_list

  versioning {
    enabled = var.enabled_disabled_versioning
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = var.sse_algorithm
      }
    }
  }

  tags = {
    Environment = var.tag
  }
}
