```sh
go install golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest
go install github.com/lotusirous/gostdsym/stdsym@latest
go install github.com/cweill/gotests/gotests@latest
```


# golangci-lint
curl -sSfL https://golangci-lint.run/install.sh | sh -s -- -b $(go env GOPATH)/bin v2.13.2
