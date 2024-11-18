# 第 1 周作业

## 作业一

实践 Terraform，开通腾讯云虚拟机，并安装 Docker。

[实现](docker_on_cvm/)思路：

- 通过 `tencentcloud_instance` 创建 CVM。
- 通过 null_resource 的 `remote-exec` provisioner 安装 docker。

### 执行

```bash
# 进入对应目录
cd docker_on_cvm

# 初始化 terraform
terraform init

# 查看 terraform plan
terraform plan

# 置备和安装
terraform apply
```

## 作业二

使用 YAML to Infra 模式创建云 Redis 数据库。

实现思路：

- [在 CVM 上安装 k3s](k3s_on_cvm)。
- [部署 crossplane](k3s_on_cvm/main.tf#L35-L42)。
- 利用 crossplane [创建腾讯云 Redis 数据库](crossplane)。

### 执行

首先，准备一个 K8S 环境，并部署 crossplane：

```bash
# 在 CVM 上安装 k3s
cd k3s_on_cvm

# 初始化和置备
terraform init
terraform plan
terraform apply

# 获取 k3s 或 TKE 集群的连接方式
export KUBECONFIG=$(pwd)/kubeconfig.yaml
```

然后，利用 crossplane 创建 Redis 数据库：

```bash
cd ../crossplane

# 准备 secrets，主要用于腾讯云认证
export TENCENTCLOUD_SECRET_ID="..."
export TENCENTCLOUD_SECRET_KEY="..."
envsubst < secrets.yaml | kubectl apply -f -

# 部署腾讯云 provider
kubectl apply -f provider.yaml

# 准备 VPC 和子网
kubectl apply -f network.yaml

# 调整 redis.yaml 中的 vpcId 和 subnetId，然后部署 redis
kubectl apply -f redis.yaml
```
