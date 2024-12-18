### 1. Check Go version:
    go version

### 2. Install beego:
    go install github.com/beego/bee/v2@latest

### 3. Add Beego CLI to Your PATH:
    echo "export PATH=\$PATH:\$(go env GOPATH)/bin" >> ~/.bashrc
    source ~/.bashrc

### 4. Verify Bee Installation:
    bee version

### 5. Create a New Beego Project:
    bee new cat-api

### 6. Navigate to the Project Directory:
    cd cat-api

### 7. Run the Application:
    bee run

## If get error:

### 8. Ensure Go Modules are Enabled Beego v2 relies on Go modules, so make sure they are enabled in your project:
    export GO111MODULE=on

### 9. Initialize the Go Modules for Your Project If you haven't initialized Go modules yet, do so in your project directory:
    go mod init cat-api

### 10.  Download Dependencies Run the following command to download the missing dependencies:
    go mod tidy

### 11. Rebuild and Run the Application Try running your application again:
    bee run
