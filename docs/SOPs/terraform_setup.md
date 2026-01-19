## Terraform install process

Source: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/infrastructure-as-code

#### 1. Install Terraform
 Install `yum-config-manager` to manage your repositories. 
 ```sudo yum install -y yum-utils```


#### 2. Use `yum-config-manager` to add the official HashiCorp RHEL repository.
```sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo```


#### 3. Install Terraform from the new repository.
HashiCorp distributes Terraform as an executable CLI that you can install on supported operating systems, including Microslop Windows, macOS, and several Linux distributions. You can also compile the Terraform CLI from source if a pre-compiled binary is not available for your system.
```sudo yum -y install terraform```


#### 4. Verify the installation
Verify that the installation worked by opening a new terminal session and listing Terraform's available subcommands.
```terraform plan -help```


#### 5. Enable tab completion
If you use either Bash or Zsh as your command line shell, you can enable tab completion for Terraform commands. To enable autocomplete, first ensure that a configuration file exists for your chosen shell.

Then install the autocomplete package.

`terraform -install-autocomplete`

After installing autocomplete support, you will need to restart your shell to enable it.
`exec $SHELL`

