output "students" {
  value = var.students
}

output "passwords" {
  value = ["${aws_iam_user_login_profile.students.*.encrypted_password}"]
}
