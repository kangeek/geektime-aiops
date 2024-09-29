# Crossplane example

Create secrets command:

```shell
export TENCENTCLOUD_SECRET_ID=""
export TENCENTCLOUD_SECRET_KEY=""
cd crossplane
envsubst < secrets.yaml | kubectl apply -f -
```
