terraform {
  required_providers {
    illumio-cloudsecure = {
      source  = "illumio/illumio-cloudsecure"
      version = "~> 1.0.11"
    }
  }
}

provider "aws" {
  profile = "personal-full"
  region  = "us-east-1"
}

provider "illumio-cloudsecure" {
  client_id     = var.cloudsecure_client_id
  client_secret = var.cloudsecure_client_secret
}

data "aws_partition" "current" {}

resource "random_password" "role_secret" {
  length      = 36
  special     = false
  upper       = false
  min_numeric = 6
}

resource "aws_iam_role_policy" "read" {
  name = "${var.iam_name_prefix}Policy"
  role = aws_iam_role.role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "apigateway:GET",
          "autoscaling:Describe*",
          "cloudtrail:DescribeTrails",
          "cloudtrail:GetTrailStatus",
          "cloudtrail:LookupEvents",
          "cloudwatch:Describe*",
          "cloudwatch:Get*",
          "cloudwatch:List*",
          "codedeploy:List*",
          "codedeploy:BatchGet*",
          "directconnect:Describe*",
          "docdb-elastic:GetCluster",
          "docdb-elastic:ListTagsForResource",
          "dynamodb:List*",
          "dynamodb:Describe*",
          "ec2:Describe*",
          "ec2:SearchTransitGatewayMulticastGroups",
          "ecs:Describe*",
          "ecs:List*",
          "elasticache:Describe*",
          "elasticache:List*",
          "elasticfilesystem:DescribeAccessPoints",
          "elasticfilesystem:DescribeFileSystems",
          "elasticfilesystem:DescribeTags",
          "elasticloadbalancing:Describe*",
          "elasticmapreduce:List*",
          "elasticmapreduce:Describe*",
          "es:ListTags",
          "es:ListDomainNames",
          "es:DescribeElasticsearchDomains",
          "fsx:DescribeFileSystems",
          "fsx:ListTagsForResource",
          "health:DescribeEvents",
          "health:DescribeEventDetails",
          "health:DescribeAffectedEntities",
          "kinesis:List*",
          "kinesis:Describe*",
          "lambda:GetPolicy",
          "lambda:List*",
          "logs:TestMetricFilter",
          "logs:DescribeSubscriptionFilters",
          "organizations:Describe*",
          "organizations:List*",
          "rds:Describe*",
          "rds:List*",
          "redshift:DescribeClusters",
          "redshift:DescribeLoggingStatus",
          "route53:List*",
          "s3:GetBucketLogging",
          "s3:GetBucketLocation",
          "s3:GetBucketNotification",
          "s3:GetBucketTagging",
          "s3:ListAllMyBuckets",
          "sns:List*",
          "sqs:ListQueues",
          "states:ListStateMachines",
          "states:DescribeStateMachine",
          "support:DescribeTrustedAdvisor*",
          "support:RefreshTrustedAdvisorCheck",
          "tag:GetResources",
          "tag:GetTagKeys",
          "tag:GetTagValues",
          "xray:BatchGetTraces",
          "xray:GetTraceSummaries",
          "networkmanager:ListCoreNetworks",
          "networkmanager:GetCoreNetwork",
          "networkmanager:ListAttachments",
          "networkmanager:GetVpcAttachment",
          "networkmanager:GetSiteToSiteVpnAttachment",
          "networkmanager:GetConnectAttachment",
          "networkmanager:GetTransitGatewayRouteTableAttachment",
          "networkmanager:ListPeerings",
          "networkmanager:GetTransitGatewayPeering",
          "networkmanager:GetTransitGatewayRegistrations"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "protection" {
  count = var.mode == "ReadWrite" ? 1 : 0
  name = "${var.iam_name_prefix}ProtectionPolicy"
  role = aws_iam_role.role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:UpdateSecurityGroupRuleDescriptionsIngress",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
          "ec2:ModifySecurityGroupRules",
          "ec2:DescribeTags",
          "ec2:CreateTags",
          "ec2:DeleteTags",
          "ec2:DescribeNetworkAcls",
          "ec2:CreateNetworkAclEntry",
          "ec2:ReplaceNetworkAclEntry",
          "ec2:DeleteNetworkAclEntry"
        ],
        Resource = [
          "arn:aws:ec2:*:*:security-group-rule/*",
          "arn:aws:ec2:*:*:security-group/*",
          "arn:aws:ec2:*:*:network-acl/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "role" {
  name = "${var.iam_name_prefix}Role"
  tags = var.tags
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          AWS = "arn:${data.aws_partition.current.partition}:iam::${var.illumio_cloudsecure_account_id}:root"
        }
        Action    = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "sts:ExternalId" = random_password.role_secret.result
          }
        }
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/SecurityAudit"
  ]
}

# Data source to get the AWS account ID.
data "aws_caller_identity" "current" {}

# Data source to get the AWS org. If account is not part of an org, comment this
data "aws_organizations_organization" "current" {}

// Onboards this AWS account with CloudSecure.
resource "illumio-cloudsecure_aws_account" "account" {
  account_id       = data.aws_caller_identity.current.account_id
  mode             = var.mode
  name             = var.name
  organization_id  = data.aws_organizations_organization.current.id # Comment this line if account is not part of an org
  role_arn         = aws_iam_role.role.arn
  role_external_id = random_password.role_secret.result
}