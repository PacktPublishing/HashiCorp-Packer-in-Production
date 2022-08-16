#!/bin/bash

# Example of AWS
vault secrets enable aws
vault write aws/config/root \
    access_key=$AWS_ACCESS_KEY_ID \
    secret_key=$AWS_SECRET_ACCESS_KEY \
    region=us-east-1
vault write aws/roles/packer \
    credential_type=iam_user \
    policy_document=@aws_packer_policy.json
EOF

vault read aws/creds/packer

# Example of Azure
vault secrets enable azure
vault write azure/config \
    subscription_id=$AZURE_SUBSCRIPTION_ID \
    tenant_id=$AZURE_TENANT_ID \
    client_id=$AZURE_CLIENT_ID \
    client_secret=$AZURE_CLIENT_SECRET \
    use_microsoft_graph_api=true
vault write azure/roles/packer \
    application_object_id=<packer_app_obj_id> \
    ttl=15m

vault read azure/creds/packer

# Example of GCP
vault secrets enable gcp
vault write gcp/config credentials=@packer.json
vault write gcp/roleset/packer \
    project="your-packer-project" \
    secret_type="access_token"  \
    token_scopes="https://www.googleapis.com/auth/cloud-platform" \
    bindings=@gcp_bindings.hcl

vault read gcp/roleset/packer/token
