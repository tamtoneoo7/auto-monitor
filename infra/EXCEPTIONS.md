# Accepted findings (exception register)

Every finding that is not fixed in the code is listed here with a reason.
The same reason is written next to the resource in the Terraform file
(`#checkov:skip`, `#tfsec:ignore`, `#trivy:ignore`), so the scanners and the
reviewers see the same decision.

- **Owner:** repository owner (tamtoneoo7)
- **Review by:** 2027-02-23 (every exception is reconsidered at that date)
- **Rule:** an exception needs an ID, a reason, and a compensating control.
  A scanner rule is never removed from the pipeline configuration.

| ID | Finding (tool and rule) | Where | Why it is accepted | Compensating control |
|---|---|---|---|---|
| E-01 | Public load balancer (Trivy AWS-0053, tfsec AVD-AWS-0053) | `compute.tf` `aws_lb.main` | The application must be reachable from the internet. | Security group allows only 443 and 4000. TLS 1.2+ policy. |
| E-02 | No web application firewall (Checkov CKV2_AWS_28) | `compute.tf` `aws_lb.main` | WAF planned for a later iteration (cost and rule tuning). | HTTPS only, restricted ports, access logs enabled. |
| E-03 | Outbound traffic to any address (Trivy AWS-0104, CRITICAL) | `security_groups.tf` `app_https_out` | The host pulls images and calls LLM and AWS APIs. Their addresses cannot be listed. | Port 443 only. VPC flow logs record all traffic. Planned: VPC endpoints and an egress proxy. |
| E-04 | Log bucket not encrypted with a customer key (Checkov CKV_AWS_145, Trivy and tfsec AWS-0132) | `storage.tf` logs bucket | Load balancer log delivery supports SSE-S3 only. | Encrypted at rest (SSE-S3), public access blocked, TLS enforced. |
| E-05 | No S3 event notifications (Checkov CKV2_AWS_62), 2 buckets | `storage.tf` | No consumer needs bucket events yet. | Access logging on the backup bucket. |
| E-06 | No cross-region replication (Checkov CKV_AWS_144), 2 buckets | `storage.tf` | Single region by design. Replication doubles storage cost. | Versioning, 7-day database backups, multi-AZ database. |
| E-07 | Key policy uses `*` as resource (Checkov CKV_AWS_109, CKV_AWS_111, CKV_AWS_356) | `kms.tf` | In a key policy `*` means "this key". Checks target ordinary IAM policies (false positive). | Access limited to the account root and to CloudWatch Logs with an encryption context condition. |
| E-08 | Log bucket has no access logging (tfsec AVD-AWS-0089) | `storage.tf` | Logging the log bucket would write into itself. | Versioning and public access block. |
| E-09 | Wildcard in the flow log policy (tfsec AVD-AWS-0057) | `iam.tf` | `...:*` is the required suffix to write log streams of one named log group. | The policy covers a single log group only. |

## Fixed instead of accepted

| Finding | Fix |
|---|---|
| Availability zones read from a data source that can change (Checkov CKV_AWS_394) | Zones pinned in `variables.tf`. |
| Target groups without health check (Checkov CKV_AWS_261, 2 groups) | `health_check` added to both. |
