remote_state {
  backend = "s3"
  config = {

    bucket         = get_env("TEST_STATE_S3_BUCKET", "")

    key            = "${path_relative_to_include()}/terraform.tfstate"

    region         = get_env("TEST_STATE_REGION", "")

    encrypt        = true

    dynamodb_table = get_env("TEST_STATE_DYNAMODB_TABLE", "")

  }
}
