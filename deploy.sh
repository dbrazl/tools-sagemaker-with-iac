#!/usr/bin/env bash
export ENVIRONMENT=${1}
echo $ENVIRONMENT

if [-z "$1"]
  then
    echo "No ENVIRONMENT provided, setting it to: ${ENVIRONMENT}"
  else
    echo "Setting the ENVIRONMENT to: ${1}"
fi

export PARAMETERS="./parameters/sagemaker-parameters-${ENVIRONMENT}.json"

export STACK_NAME=$(jq -r ".Parameters.DomainName" $PARAMETERS)
echo "STACK_NAME: ${STACK_NAME}"

export BUCKET_NAME=$(jq -r ".Parameters.S3Bucket", $PARAMETERS)
echo "BUCKET_NAME: ${BUCKET_NAME}"

export VpcId=$(jq -r ".Parameters.VPCId" $PARAMETERS)
echo "VpcId: ${VpcId}"

export SubnetsIds=$(jq -r ".Parameters.SubnetIds" $PARAMETERS)
echo "SubnetIds: ${SubnetIds}"

/usr/local/bin/aws cloudformation deploy \
  --template-file sagemaker_studio.yml
  --capabilities CAPABILITY_IAM \
  --parameter-overrides \
  $(jq -r '.Parameters | keys [] as $k | "\($k)=\(.[$k])"' $PARAMETERS) \
  --stack-name ${STACK_NAME}