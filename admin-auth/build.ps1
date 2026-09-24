$ErrorActionPreference = 'Stop'
$previousGoModule = $env:GO111MODULE
$previousGoOs = $env:GOOS
$previousGoArch = $env:GOARCH
$previousCgo = $env:CGO_ENABLED
Push-Location $PSScriptRoot
try {
    $env:GO111MODULE = 'off'
    $env:GOOS = 'windows'
    $go = "go"
    $localGo = Join-Path $PSScriptRoot "..\.tools\go\bin\go.exe"
    if (Test-Path $localGo) { $go = (Resolve-Path $localGo).Path }
    & $go test .
    if ($LASTEXITCODE -ne 0) { throw 'Tests failed' }
    $env:GOOS = 'linux'
    $env:GOARCH = 'arm64'
    $env:CGO_ENABLED = '0'
    & $go build -trimpath -ldflags '-s -w' -o admin-gateway .
    if ($LASTEXITCODE -ne 0) { throw 'Build failed' }
} finally {
    $env:GO111MODULE = $previousGoModule
    $env:GOOS = $previousGoOs
    $env:GOARCH = $previousGoArch
    $env:CGO_ENABLED = $previousCgo
    Pop-Location
}
