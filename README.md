# terragrunt + terraform 结合的使用模板

### 栗子一： 使用本地写好的module
创建一个 gcs bucket
```
gcp/prod/gcs/terragrunt.hcl
```

## 栗子二： 使用terraform registry 的module
创建一个 gke 集群
* 注意 ip_range, service_range 需要提前在 subnet 里创建好。参考 https://cloud.google.com/kubernetes-engine/docs/concepts/alias-ips
```
gcp/prod/gke/terragrunt.hcl
```