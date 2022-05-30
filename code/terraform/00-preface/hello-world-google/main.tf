terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

# You have to adjust the path to your credentials

provider "google" {
  credentials = file("/home/mark/mark.json")

  project = "hadoop-setup-245603"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}
