# Imbox
Imbox is a simple TUI tool for reading `.mbox` files. Inspired by a gmail export I did.

**It is not a mail client**

## Features
- List emails from oldest to newest in an upper list pane
- Read selected email in a lower reader pane

## Planned features
- Change email sort
- Search
- Threading
- Deleting Emails (maybe)
- Save attachments


## Running locally
- `go run *.go open [path/to/mbox]`

## Building
- `go build -o bin/imbox` will build an executable file for the current OS and put it in `./bin`
- `go install` will build an executable for the current OS and put it in `$GOPATH/bin`
- Building for different platforms
  - You can modify GOOS and GOARCH environment variables to build for other platforms
  - See `go tool dist list` for a list of `os/arch` values
  - Example `GOOS=windows GOARCH=amd64 go build`
