# geektime-aiops

极客时间 AIOps 训练营作业。

## 准备

准备工作包括如下内容，相关代码在 [common/tencentcloud](common/tencentcloud/)：

### 准备腾讯云 AKSK

```bash
export TENCENTCLOUD_SECRET_ID="..."
export TENCENTCLOUD_SECRET_KEY="..."
```

### 准备 tfstate on COS

在准备 COS 之前是无法配置 `backend "cos"` 的，可以通过如下过程置备和迁移 tfstate：

1. 先注释掉[相关代码](common/tencentcloud/main.tf#L9-L17)，并执行 `terraform apply` 命令创建 COS。
1. 然后取消注释，注意确定 COS backend 的配置，尤其是 `bucket` 的名字，然后执行 `terraform init` 按提示将当前状态文件迁移到新的 COS 后端存储。

## 示例

课上示例见 [lessons](lessons/)。

## 作业

作业代码见 [homeworks]，其中：

[第 1 周作业](./homeworks/week1/)

- 实践 Terraform，开通腾讯云虚拟机，并安装 Docker。
- 使用 YAML to Infra 模式创建云 Redis 数据库。

## 附录

- [腾讯云的 terraform provider](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs)
- [腾讯云的 crossplane provider](https://marketplace.upbound.io/providers/crossplane-contrib/provider-tencentcloud)
- [CrossPlane 文档](https://docs.crossplane.io/latest/)
- [Argo CD 文档](https://argo-cd.readthedocs.io/en/stable/)
