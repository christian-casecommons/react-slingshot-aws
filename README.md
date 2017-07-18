# react-slingshot-aws demo

First, we need to generate a certificate; open the Makefile and edit the following lines
```
AWS_ACCOUNT_ID ?= 610547539895
DOMAIN ?= callowayart.com
ALT_DOMAINS ?= react-slingshot.callowayart.com,callowayart.com
```

To generate the certificate, execute the following
```
AWS_PROFILE=yourprofile make certificate
```

You will need to approve the certificate for the given domains that you have specified; please open the adminstrator email account for your domain and click to approve
![image](https://user-images.githubusercontent.com/23318225/28540161-4ed6635a-7082-11e7-801f-54613252ed10.png)

Next, open up ./group_vars/dev/vars.yml and edit the following lines, making sure to specify your appropriate arn values and domains
```
Sts.Role: arn:aws:iam::610547539895:role/admin
Stack.Template: templates/stack.yml.j2

Stack.Inputs.FullyQualifiedDomainName: react-slingshot.callowayart.com
Stack.Inputs.DomainName: callowayart.com
Stack.Inputs.AcmCertificateArn: arn:aws:acm:us-east-1:610547539895:certificate/fd76420a-9b3c-4ed0-ac33-08503da1c751
```

Run the playbook
```
 AWS_PROFILE=yourprofile ansible-playbook site.yml -e env=dev -vv
```

Finally, we need to deploy the application; to this run the following:
```
AWS_PROFILE=yourprofile make deploy
```