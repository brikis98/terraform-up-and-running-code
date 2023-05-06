# Example 7-1 Root Module


module "Bucket" {
    source = "../bucket"
    bname = var.bucket_name

}
