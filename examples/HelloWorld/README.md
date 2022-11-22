# Logs

```shell
mkdir -p examples/HelloWorld
cd examples/HelloWorld

# create a function
func new \
    --name HttpExample \
    --template "Http Trigger" \
    --worker-runtime custom

# build a function
cd HttpExample
make build

# run server locally
cd ../
func start

# curl http://localhost:7071/api/HttpExample -vvvv
```

# References

- [Quickstart: Create a Go or Rust function in Azure using Visual Studio Code](https://learn.microsoft.com/en-us/azure/azure-functions/create-first-function-vs-code-other?tabs=go%2Cwindows)
