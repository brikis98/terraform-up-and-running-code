output "Integration_Test_1" {
    value = (module.hello_app.my_instance.vpc_security_group_ids == module.SecGrp.secgps)
}