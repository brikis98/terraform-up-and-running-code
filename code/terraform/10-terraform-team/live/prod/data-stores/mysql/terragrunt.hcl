terraform {
  source = "../../../../modules//data-stores/mysql"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  db_name     = "example_prod"

  # Set the username using the TF_VAR_db_username environment variable
  # Set the password using the TF_VAR_db_password environment variable
}
