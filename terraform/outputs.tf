output "ip_addressess" {
  value = [ for i in range(length(var.devs)): template_file.output[i].rendered ]
}
