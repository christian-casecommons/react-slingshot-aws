# Variables
PROJECT_NAME ?= react-slingshot
AWS_ACCOUNT_ID ?= 610547539895
DOMAIN ?= callowayart.com
ALT_DOMAINS ?= react-slingshot.callowayart.com,callowayart.com

include Makefile.settings


.PHONY: certificate
certificate:
	${INFO} "Creating stack.."
	aws cloudformation create-stack \
		--region us-east-1 \
		--stack-name certificate-$(PROJECT_NAME) \
		--template-body file://./templates/certificate.yml.j2 \
		--parameters \
				ParameterKey=DomainName,ParameterValue='"$(DOMAIN)"' \
				ParameterKey=AlternativeDomainNames,ParameterValue='"$(ALT_DOMAINS)"'
	aws cloudformation wait stack-create-complete \
		--stack-name certificate-$(PROJECT_NAME)

.PHONY: deploy
deploy:
	${INFO} "Creating build artifacts.."
	#@ rm -rf ./build/react-slingshot && mkdir -p ./build
	#git clone https://github.com/coryhouse/react-slingshot ./build/react-slingshot

	cd ./build/react-slingshot && \
		echo "Y Y Y Y Y" | npm run setup && \
		babel-node ./tools/build.js

	${INFO} "Uploading static site to s3"
	aws s3 cp \
		--recursive \
		--include=* \
			./build/react-slingshot/dist/ s3://react-slingshot.$(DOMAIN)/

## COMMENTED OUT ##############################################################
ifeq (0,1)
.PHONY: destroy
destroy:
	${INFO} "Destroying resources.."
	- aws s3 rb \
			--force s3://react-slingshot.$(DOMAIN) 2>/dev/null
	- aws cloudformation delete-stack --stack-name $(PROJECT_NAME) 2>/dev/null
	- aws cloudformation wait stack-delete-complete --stack-name $(PROJECT_NAME)

.PHONY: release
release:
	${INFO} "Creating stack.."
	aws cloudformation create-stack \
		--stack-name $(PROJECT_NAME) 2>/dev/null \
		--template-body file://./templates/stack.yml.j2
		--parameters \
				ParameterKey=DomainName,ParameterValue='"$(DOMAIN)"' \
				ParameterKey=FullyQualifiedDomainName,ParameterValue='"$(PROJECT_NAME).$(DOMAIN)"' \
				ParameterKey=AcmCertificateArn,ParameterValue='"ReactSlingshotAcmCertificateArn' \

	aws cloudformation wait stack-create-complete \
		--stack-name $(PROJECT_NAME)

	deploy
endif

