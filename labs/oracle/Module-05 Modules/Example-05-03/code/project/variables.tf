

variable machine_names {
    type = list(string)
    default = ["Singleton"]
}

variable machine_amis {
    type = list(string)
    default = ["ami-077e31c4939f6a2f3"]
}

variable machine_types {
    type = list(string)
    default = ["t2.nano"]
}