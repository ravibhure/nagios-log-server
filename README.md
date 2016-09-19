Deployment Code of Nagios Log Server
=========================

This provides a template for running a simple Nagios Log Server on Digital Ocean.

* nagios_log_server

To simplify the example, this intentionally ignores deploying and
getting your application onto the servers. However, you could do so either via
[provisioners](https://www.terraform.io/docs/provisioners/) and a configuration
management tool, or by pre-baking configured AMIs with
[Packer](http://www.packer.io).

After you run `terraform apply` on this configuration, it will
automatically output the testnow and watchdog url. After your instance
registers and successful run with shell script, this should respond with the default nagios log server web page.

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
