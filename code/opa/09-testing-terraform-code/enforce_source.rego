package enforce_source

allow = true {
    count(violation) == 0
}

violation[module_label] {
    some module_label, i
    startswith(input.module[module_label][i].source, "github.com/brikis98") == false
}