# EKS DevOps Learning Project - Plan

## Project Overview

**Type**: Personal Learning Project  
**Duration**: 6-8 weeks (10-15 hours/week)  
**Goal**: Build production-grade Kubernetes infrastructure on AWS using modern DevOps practices  
**Monthly Cost**: ~$120 (can reduce to ~$70 with on-demand usage)

---

## Technology Stack

### Infrastructure (Terraform)
- AWS VPC (networking foundation)
- EKS (managed Kubernetes)
- Route53 (DNS)
- AWS Secrets Manager (secret storage)
- S3 (Terraform state, log storage)

### Platform Services (Kubernetes)
- ArgoCD (GitOps continuous delivery)
- AWS Load Balancer Controller (ALB integration)
- External Secrets Operator (sync secrets from AWS)
- Prometheus + Grafana (metrics and dashboards)
- Loki + Promtail (log aggregation)
- Kustomize (YAML templating)
- Kaprenter/autoscaler (not yet disclosed)

### Application
- Simple stateless web app
- In-memory data storage (no database)
- Health checks and observability

---

## Repository Structure

```
project-root/
├── terraform/
│   ├── infrastructure/    # VPC, S3 (persistent)
│   ├── eks/              # EKS cluster (ephemeral)
│   └── bootstrap/        # ArgoCD installation
├── k8s-bootstrap/        # Platform services (ArgoCD manages)
│   ├── applications/     # ArgoCD app definitions
│   └── platform/         # Platform service configs
├── k8s-apps/            # Your applications
│   └── demo-app/
│       ├── base/
│       └── overlays/
└── docs/
```

---

## Learning Modules

### Module 1: Infrastructure Foundation (Week 1-2)

**Week 1: VPC + EKS**

**Learning Objectives**:
- Terraform for AWS infrastructure
- EKS architecture and networking
- IAM Roles for Service Accounts (IRSA)

**What You'll Build**:
- VPC with public/private subnets in 2 AZs
- Single NAT gateway (cost optimization)
- EKS cluster with 2 small nodes
- IRSA OIDC provider

**Key Deliverables**:
- Working EKS cluster
- kubectl access configured
- Terraform state in S3
- Basic architecture documentation

**Validation**: Can connect to cluster and see nodes running

---

**Week 2: EKS Add-ons + ArgoCD**

**What You'll Build**:
- EKS add-ons (VPC CNI, CoreDNS, EBS CSI driver)
- AWS Load Balancer Controller with IRSA
- ArgoCD installation
- App-of-Apps pattern setup

**Key Deliverables**:
- All cluster add-ons operational
- ArgoCD accessible and configured
- Root app deployed

**Validation**: ArgoCD UI accessible, can create test applications

**Key Concepts**: Kubernetes Operators, GitOps principles, bootstrapping strategy

---

### Module 2: Secret Management (Week 3)

**Learning Objectives**:
- Why Kubernetes Secrets aren't enough
- External secret management patterns
- IRSA authentication flow

**What You'll Build**:
- AWS Secrets Manager setup
- IAM policy and IRSA role for External Secrets Operator
- ClusterSecretStore configuration
- Test secret synchronization

**Key Deliverables**:
- ESO running and managed by ArgoCD
- Secrets syncing from AWS to Kubernetes
- Documentation on adding new secrets

**Validation**: Can create secret in AWS and see it appear in Kubernetes automatically

**Key Concepts**: Why secrets shouldn't be in Git, automatic sync and rotation, separation of concerns

---

### Module 3: Observability Stack (Week 4-5)

**Week 1: Metrics (Prometheus + Grafana)**

**Learning Objectives**:
- Prometheus metrics collection
- PromQL query language
- Grafana dashboards and datasources

**What You'll Build**:
- kube-prometheus-stack deployment
- Pre-built dashboards (cluster, node, pod metrics)
- Basic alerting rules
- Access via port-forward or Ingress

**Key Deliverables**:
- Prometheus collecting metrics from all cluster components
- Grafana accessible with working dashboards
- Test alerts configured

**Learning Activities**:
- Query pod CPU/memory usage
- Create alert for pod restarts
- Trigger alert with crashlooping pod
- Understand PromQL basics

**Key Concepts**: Difference between metrics and logs, time-series data, alerting philosophy

---

**Week 2: Logs (Loki + Promtail)**

**What You'll Build**:
- S3 bucket for log storage with IRSA
- Loki deployment
- Promtail DaemonSet (log collection)
- Loki datasource in Grafana

**Key Deliverables**:
- Loki collecting logs from all pods
- Logs queryable in Grafana
- Basic log dashboard

**Learning Activities**:
- Write LogQL queries
- Filter logs by namespace/pod
- Correlate metrics with logs during an incident
- Understand log retention policies

**Key Concepts**: Why object storage for logs, DaemonSets, structured logging benefits

---

### Module 4: Application Deployment (Week 6)

**Week 1: App Creation + Kustomize**

**Learning Objectives**:
- Kustomize base and overlays
- Kubernetes best practices
- Container lifecycle

**What You'll Build**:
- Simple stateless web application
- Dockerfile and container image
- Kustomize manifests (base + overlay)
- Proper health checks, resource limits, security contexts

**Key Deliverables**:
- Containerized app in ECR
- Well-structured Kustomize manifests
- Resource limits and security settings
- Health checks implemented

**Validation**: Can deploy app manually with kubectl, app responds to requests

**Key Concepts**: Base vs overlays, DRY principle, security contexts, probe types

---

**Week 2: GitOps Workflow**

**What You'll Build**:
- ArgoCD Application for demo app
- Automated sync from Git
- Rolling update strategy

**Learning Activities**:
- Deploy via ArgoCD (commit to Git, watch sync)
- Update image tag, observe rolling update
- Manually change deployment, watch ArgoCD revert (drift detection)
- Break things intentionally:
  - Remove liveness probe (learn why both probes matter)
  - Set memory too low (learn OOMKilled debugging)
  - Wrong environment variable (learn CrashLoopBackOff)
  - Remove resource requests (learn scheduling issues)

**Key Deliverables**:
- App deployed via GitOps
- Understanding of rolling updates
- Troubleshooting methodology documented
- Custom Grafana dashboard for app

**Key Concepts**: Git as source of truth, drift detection, self-healing, immutable infrastructure

---

### Module 5: Integration & Hardening (Week 7-8)

**Week 1: Ingress + DNS**

**What You'll Build**:
- Ingress resource for demo app
- ALB creation via Load Balancer Controller
- DNS configuration (Route53 or free alternative)
- Optional: SSL certificate

**Key Deliverables**:
- Public access to demo app
- DNS working
- Health checks at ALB level

**Validation**: Can access app via browser with domain name

**Key Concepts**: Ingress controllers, ALB vs NLB, DNS propagation, TLS termination

---

**Week 2: Security + Instrumentation**

**What You'll Build**:
- Network policies (default deny, specific allows)
- Pod security contexts review
- Prometheus metrics endpoint in app
- Structured logging (JSON format)
- Custom Grafana dashboard for app metrics
- PodDisruptionBudget

**Learning Activities - Chaos Engineering**:
- Kill a pod, watch automatic recreation
- Drain a node, observe pod rescheduling
- Generate high load, observe autoscaling
- Correlate metrics + logs during incidents

**Key Deliverables**:
- Network policies enforced
- Application instrumented
- Complete observability for your app
- Chaos experiments documented

**Final Documentation**:
- Architecture diagram
- Runbook for common tasks
- Incident response guide
- Lessons learned document

**Key Concepts**: Defense in depth, least privilege, observability-driven development, chaos engineering

---

## Bootstrap Strategy

**Problem**: After destroying cluster, how to restore everything quickly?

**Solution**: Three-layer Terraform + ArgoCD App-of-Apps

**Layers**:
1. **Infrastructure** (rarely destroyed): VPC, S3 buckets
2. **EKS** (can destroy/recreate): Cluster, nodes, IAM roles
3. **Bootstrap** (minimal): Just ArgoCD installation

**How It Works**:
- Terraform installs only ArgoCD
- ArgoCD deploys everything else from Git
- All platform services defined as ArgoCD Applications
- Rebuild time: ~20-30 minutes, fully automated

**Rebuild Procedure**:
1. Run terraform apply on infrastructure
2. Run terraform apply on EKS (~15 min)
3. Run terraform apply on bootstrap (~2 min)
4. Wait for ArgoCD to sync platform services (~10 min)
5. Done - everything restored from Git

---

## Cost Management

### Monthly Breakdown
- EKS control plane: $72 (fixed)
- 2x t3.small nodes: $30
- NAT gateway: $32
- ALB: $16
- EBS volumes: $5
- Secrets Manager: $2
- S3 (state + logs): $2
- Route53: $0.50

**Total: ~$160/month**

### Optimization Strategies

**Option 1: On-Demand Usage**
- Destroy EKS cluster when not using
- Keeps VPC/S3, destroys compute
- Saves ~$50/month
- Rebuild in 20 minutes when needed

**Option 2: Smaller Instances**
- Use t3.micro nodes
- Saves ~$15/month
- May be slower for learning

**Option 3: Complete Teardown**
- Destroy everything between sessions
- Only keep S3 state bucket
- Rebuild entire stack when learning
- Lowest cost, highest rebuild time

**Recommendation**: Use Option 1 (destroy EKS, keep VPC/S3)

---

## Success Criteria

### Technical Skills Gained
- Provision AWS infrastructure with Terraform
- Deploy and manage EKS clusters
- Implement GitOps with ArgoCD
- Manage secrets securely
- Configure comprehensive observability
- Deploy applications with Kustomize
- Troubleshoot production issues systematically
- Understand cloud cost management

### Interview Readiness
Can confidently discuss:
- Architecture decisions and trade-offs
- Security patterns and best practices
- GitOps workflow and benefits
- Troubleshooting methodology
- Observability correlation (metrics + logs)
- When to use managed vs self-hosted

### Portfolio Value
GitHub repos demonstrate:
- Production-grade Terraform structure
- Well-organized Kubernetes manifests
- GitOps best practices
- Security-first approach
- Comprehensive documentation

---

## Common Pitfalls

**Terraform State Loss**: Always use S3 backend with versioning

**Secrets in Git**: Use External Secrets Operator, never plain K8s Secrets in Git

**Missing Resource Limits**: Always set both requests and limits

**No Health Checks**: Always implement liveness and readiness probes

**Insufficient Logging**: Use structured logging from day 1

**Manual Changes**: Everything must be in Git for GitOps to work

**Cost Overruns**: Set AWS budgets, destroy when not using, monitor daily

---

## Project Timeline

```
Week 1-2: Foundation (VPC, EKS, ArgoCD)
    ↓
Week 3: Secrets (External Secrets Operator)
    ↓
Week 4-5: Observability (Prometheus, Grafana, Loki)
    ↓
Week 6: Application (Demo app, Kustomize, GitOps)
    ↓
Week 7-8: Integration (Ingress, DNS, Security, Chaos)
```

---

## After Completion

### Advanced Topics to Explore
- Multi-cluster management
- Service mesh (Istio/Linkerd)
- Advanced GitOps (FluxCD, progressive delivery)
- Policy as code (OPA/Gatekeeper)
- Cost optimization (Karpenter, Spot instances)
- CI/CD pipelines (GitHub Actions)
- Distributed tracing

### Certifications
- AWS Certified Solutions Architect - Associate
- Certified Kubernetes Administrator (CKA)
- Certified Kubernetes Application Developer (CKAD)

---

## Key Resources

**Official Documentation**:
- Terraform AWS Provider
- EKS Best Practices Guide
- Kubernetes Documentation
- ArgoCD Documentation
- Kustomize Documentation
- Prometheus Documentation

**Learning Platforms**:
- AWS EKS Workshop
- Kubernetes the Hard Way
- GitOps with ArgoCD tutorials

**Communities**:
- CNCF Slack
- Kubernetes Slack
- r/kubernetes
- AWS Forums

---

## Final Notes

**This is a learning project** - You will make mistakes. That's the entire point.

**Document everything** - Keep notes on what broke and how you fixed it.

**Iterate freely** - You'll probably rebuild parts multiple times. That's normal and valuable.

**Take breaks** - Don't rush. Learn at your own pace.

**Ask for help** - Use communities and documentation when stuck.

**Focus on understanding** - Don't just copy-paste. Understand why each piece exists.

---

**Timeline flexibility**: This is 6-8 weeks at 10-15 hours/week. Adjust based on your pace and available time.

**Budget flexibility**: Can range from $70-160/month depending on usage patterns.

**Scope flexibility**: Skip chaos engineering if time is tight. Add advanced topics if you want more depth.

The goal is learning, not perfection. Build, break, fix, repeat. 🚀