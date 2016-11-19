output "neo_arn" {
  value = "${aws_iam_user.example.0.arn}"
}

output "all_arns" {
  value = ["${aws_iam_user.example.*.arn}"]
}
