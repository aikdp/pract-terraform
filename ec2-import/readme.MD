# Import

1. Create EC2 in AWS Cloud manually
2. Take instance id. Write provider and import block in main.tf file as below
```
import {
    id = <Instance_id>
    to = aws_instance.example   #<resource>.<resource_name>
}
```
3. Now paln and generate the resource with terraform command
```
terrafrom plan -generate-config-out=generated_name.tf <instance_id>
eg: terraform paln -generate-config-out=resource_ec2.tf i-01006d6ede770bb3b
```
4. Once the resource generated in specified .tf file and copy the resource info and paste it in main.tf. You can remove the generated resource file i.e., resource_ec2.tf file.
5. Now Import the existing resource which is manually created in AWS into terraform state.
```
terraform import <resource>.<resource_name> "resource_id" 
eg: terraform import aws_instance.example " i-01006d6ede770bb3b"
```
6. Hence, you can check by giving terraform plan, it will say that No changes had been made.
```
No changes. Your infrastructure matches the configuration.
```
In this way you can manage the infrastructure that has been created manually by importing the resources metadata into statefile.
Make sure state file in remotely with locking (DynamoDB or S3 native lock)


# You want to reset your entire repo back to last commit
This will undo all local uncommitted changes (including deletions):
```
git reset --hard HEAD
```