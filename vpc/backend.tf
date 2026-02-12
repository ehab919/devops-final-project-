terraform {
  backend "local" {
    path = "terraform.tfstate"  # This is the local file where the state will be stored
  }
}


