FROM hashicorp/terraform:1.10

LABEL description="Containerized Terraform runner for AWS infrastructure"

WORKDIR /workspace

# Copy Terraform configuration and modules (filtered by .dockerignore)
COPY . .

# The base image already sets ENTRYPOINT ["terraform"]
CMD ["validate"]
