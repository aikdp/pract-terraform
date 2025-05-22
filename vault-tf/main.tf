provider "aws"{
    region = "us-east-1"
}

provider "vault" {
  address = "http://44.211.91.90:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

   parameters = {
      role_id   = "75a7457457efc79-"
      secret_id = "d1dca564573"
  }
}
}

#data Source to read the existing data
data "vault_kv_secret_v2" "example" {
  mount = "kv"
  name  = "test-secret"
}

#Now craete a resource

resource "aws_instance" "main"{
    ami = "ami-09c813fb71547fc4f"
    instance_type = "t3.micro"
    # vpc_secuirty_group_ids = ["PASTE-SG-ID"]

    tags = {
        Secret = data.vault_kv_secret_v2.example.data["username"]
    }
}