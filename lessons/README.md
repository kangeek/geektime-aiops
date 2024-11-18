# 课上示例

## 第一周：云原生基础

第一周的 demos 位于 [module2](module2) 目录下：

- [demo1](module2/demo1)：基于 terraform 在腾讯云创建一个 CVM
  - 课程视频：[3. Iac 和 Terraform 概述](https://u.geekbang.org/lesson/673?article=806303) - 案例一
- [demo2](module2/demo2)：导入现有的 terraform resource（一个 CVM）
  - 课程视频：[4. Terraform 核心命令](https://u.geekbang.org/lesson/673?article=806304) - 案例二：导入资源
- [demo3](module2/demo3)：将 terraform state 放到 COS 上
  - 课程视频：[5. Terraform 案例演示](https://u.geekbang.org/lesson/673?article=806305) - 本地 vs 远端的 Terraform 代码示例
- [demo4](module2/demo4)：创建 CVM；安装 k3s；利用 terraform helm module 部署 ArgoCD
  - 课程视频：[5. Terraform 案例演示](https://u.geekbang.org/lesson/673?article=806305) - 案例四
  - 额外内容：
    - 通过 graph 命令生成资源依赖关系图：`terraform graph | dot -Tsvg > graph.svg`
- [demo5](module2/demo5)：基于 modules + env 的方式置备资源
  - 课程视频：[5. Terraform 案例演示](https://u.geekbang.org/lesson/673?article=806305) - 案例五
- [demo6](module2/demo6)：借助 crossplane 实现 Yaml to Infra
  - 课程视频：[5. Terraform 案例演示](https://u.geekbang.org/lesson/673?article=806305) - 案例六
  - 额外内容：
    - [腾讯云的 crossplane provider](https://marketplace.upbound.io/providers/crossplane-contrib/provider-tencentcloud)
