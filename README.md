Deployment Code of Nagios Log Server
=========================

This provides a template for running a simple Nagios Log Server on Digital Ocean.

* nagios_log_server

After you run `terraform apply` on this configuration, it will
automatically output the nagios log server url. After your instance registers and successful run with shell script, this should respond with the default nagios log server web page.

* To run, configure your DO provider as described in

https://www.terraform.io/docs/providers/do/index.html

* First copy the `terraform.tfvars.example` to `terraform.tfvars` and update the digital ocean details in it.


* Prepare plan

```
terraform plan
```


* Run with a command like this:

```
terraform apply
```
