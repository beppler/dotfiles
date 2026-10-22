### Configuration

# TLS configuration
[System.Net.ServicePointManager]::SecurityProtocol = "Tls13"

# Colors
$host.PrivateData.ProgressForegroundColor = 'White'
$host.PrivateData.ProgressBackgroundColor = 'Blue'

# Keys configuration
Import-Module PSReadLine -ErrorAction SilentlyContinue

if (-not $error) {
    Set-PSReadLineKeyHandler -Chord Ctrl+d -Function DeleteCharOrExit
    Set-PSReadlineOption -BellStyle Visual
}

### Functions

function Connect-VM {
    param (
        [Parameter(Mandatory=$true)]
        [string] $VMName,
        [Parameter(Mandatory=$false)]
        [string[]] $ServerName = 'localhost'
    )

    & vmconnect.exe $ServerName $VMName
}
Set-Alias -Name vmc -Value Connect-VM

# https://www.chrisjhart.com/Windows-10-ssh-copy-id/
function Copy-SSHIdentifier {
    param (
        [Parameter(Mandatory=$true)]
        [string] $keyFileName,
        [Parameter(Mandatory=$true)]
        [string] $server
    )
    Get-Content $keyFileName | ssh $server "mkdir -p ~/.ssh; cat >> ~/.ssh/authorized_keys"
}
Set-Alias -Name ssh-copy-id -Value Copy-SSHIdentifier

# http://presthammer.wordpress.com/2014/04/15/whereis-equivalent-for-powershell/
function Get-CommandDefinition {
    <#
    .SYNOPSIS
    Get the full path of an application.
    #>
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string] $target
    )
    Get-Command -CommandType Application -ErrorAction SilentlyContinue -Name $target | Select-Object -ExpandProperty Definition
}
Set-Alias -Name whereis -Value Get-CommandDefinition
Set-Alias -Name which -Value Get-CommandDefinition

function Get-FontNames {
    (New-Object System.Drawing.Text.InstalledFontCollection).Families
}

# https://activedirectoryfaq.com/2017/08/creating-individual-random-passwords/
function Get-RandomCharacters {
    param (
        [int] $Length=20,
        [string] $Characters="0123456789ABCDEFGHJKLMNPQRSTUVWYabcdefghjklmnpqrstuwy!@#$%&*,-_.;: "
    )
    return ($Characters.ToCharArray() | Get-Random -Count $Length) -join ""
}

function Get-StringHash {
    <#
    .SYNOPSIS
    Computes the hash value for a string by using a specified hash algorithm.
    .DESCRIPTION
    The Get-StringHash cmdlet computes the hash value (converted to UTF-8) for a string by using a specified hash algorithm.
    #>
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [AllowEmptyString()]
        [string] $Value,
        [ValidateSet("SHA1", "SHA256", "SHA384", "SHA512", "MACTripleDES", "MD5", "RIPEMD160")]
        [string] $Algorithm="SHA256",
        [ValidateSet("Hex", "Base64")]
        [string] $OutFormat="Hex"
    )
    $hasher = [System.Security.Cryptography.HashAlgorithm]::Create($Algorithm)
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($Value)
    $hash = $hasher.ComputeHash($bytes)
    if ($OutFormat -eq "Base64") {
        $result = [System.Convert]::ToBase64String($hash)
    }
    else {
        $result = ([System.BitConverter]::ToString($hash) -replace '-','').ToLower()
    }
    return $result
}

function Invoke-TcpTraceRoute {
    param (
        [Parameter(Position=0, Mandatory=$false, ValueFromRemainingArguments=$true)]
        [string[]] $Arguments
    )
    wsl --exec tcptraceroute $Arguments
}
Set-Alias -Name tracetcp -Value Invoke-TcpTraceRoute

function Invoke-Dig {
    param (
        [Parameter(Position=0, Mandatory=$false, ValueFromRemainingArguments=$true)]
        [string[]] $Arguments
    )
    wsl --exec dig $Arguments
}
Set-Alias -Name dig -Value Invoke-Dig

function Invoke-Open {
    [CmdletBinding()]
    param([Parameter(ValueFromRemainingArguments = $true)]$Paths)
    if (-not $Paths) { $Paths = @(".") }
    foreach ($p in $Paths) {
        Start-Process ([string]$p)
    }
}
Set-Alias -Name open -Value Invoke-Open

function Invoke-Proxy {
    ssh -L 8888:localhost:8888 -C -N beppler.dev.br
}

function Invoke-Socks-Proxy {
    # https://imasters.com.br/devsecops/crie-um-proxy-socks-em-um-servidor-linux-com-ssh-para-ignorar-filtros-de-conteudo
    ssh -D 8888 -q -C -N beppler.dev.br
}

function New-GitIgnore {
  param(
    [Parameter(Mandatory=$true, ValueFromRemainingArguments=$true)]
    [string[]]$list
  )
  $params = $list -join ","
  Invoke-WebRequest -Uri "https://www.gitignore.io/api/$params" | Select-Object -ExpandProperty Content | Out-File -FilePath $(Join-Path -Path $pwd -ChildPath ".gitignore") -Encoding ascii
}

# http://superuser.com/a/571154 e http://superuser.com/a/540935
function Set-FileDate {
    <#
    .SYNOPSIS
    Set the file date to current date or create file if it does not exist.
    #>
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string] $file
    )
    if(Test-Path $file) {
        (Get-ChildItem $file).LastWriteTime = Get-Date
    }
    else {
        New-Item -Path $file -ItemType File
    }
}
Set-Alias -Name touch -Value Set-FileDate

function New-Symlink {
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string] $Target,
        [Parameter(Position=1, Mandatory=$true)]
        [string] $Link
    )
    New-Item -ItemType SymbolicLink -Path $Link -Value $Target
}

function Start-ElevatedProcess {
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string] $FilePath,
        [Parameter(Position=1, Mandatory=$false, ValueFromRemainingArguments=$true)]
        [string[]] $Arguments
    )
    $Options = @{ FilePath = $FilePath; Wait = !$FilePath.StartsWith("shell:appsFolder") }
    if ($Arguments) {
        $Options.ArgumentList = $Arguments
    }
    if (!(Test-IsAdmin)) {
        $Options.Verb = "runas"
    }
    Start-Process @Options
}
# Set-Alias -Name sudo -Value Start-ElevatedProcess

function Show-All-Colors {
    $colors = [enum]::GetValues([System.ConsoleColor])
    Foreach ($bgcolor in $colors){
        Foreach ($fgcolor in $colors) { Write-Host "$fgcolor|"  -ForegroundColor $fgcolor -BackgroundColor $bgcolor -NoNewLine }
        Write-Host " on $bgcolor"
    }
}

function Test-IsAdmin {
    if (($PSVersionTable.PSEdition -eq 'Desktop') -or (($PSVersionTable.PSEdition -eq 'Core') -and ($PSVersionTable.Platform -eq 'Win32NT'))) {
        return ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')
    }
    elseif (($PSVersionTable.PSEdition -eq 'Core') -and ($PSVersionTable.Platform -eq 'Unix')) {
        return ((id -u) -eq 0)
    }
    return $false
}

### Aliases
Remove-Item Alias:curl -Force -ErrorAction Ignore
Remove-Item Alias:diff -Force -ErrorAction Ignore
Remove-Item Alias:wget -Force -ErrorAction Ignore

Set-Alias -Name edit -Value "$env:LOCALAPPDATA\Microsoft\WinGet\Links\edit.exe"
Set-Alias -Name lg -Value lazygit.exe
Set-Alias -Name ll -Value Get-ChildItem
Set-Alias -Name tshark -Value "$env:ProgramFiles\Wireshark\tshark.exe"

function hcurl { & curl -s -D - -o /dev/null $args }


### Completions

# git
Import-Module PSGitCompletions -ErrorAction Ignore

# dotnet src: https://docs.microsoft.com/en-us/dotnet/core/tools/enable-tab-autocomplete
if (Get-Command -Name dotnet -CommandType Application -ErrorAction Ignore) {
    dotnet completions script pwsh | Out-String | Invoke-Expression
}

# winget src: https://github.com/microsoft/winget-cli/blob/master/doc/Completion.md
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
    $Local:word = $wordToComplete.Replace('"', '""')
    $Local:ast = $commandAst.ToString().Replace('"', '""')
    winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

# wsl
Import-Module WSLTabCompletion -ErrorAction Ignore

### Misc

Import-Module Terminal-Icons -ErrorAction Ignore

# mise
if (Get-Command -Name mise -CommandType Application -ErrorAction Ignore) {
    mise activate pwsh | Out-String | Invoke-Expression
    mise completions pwsh | Out-String | Invoke-Expression
}

# oh-my-posh
$Error.Clear()
if (Get-Command -Name oh-my-posh -CommandType Application -ErrorAction Ignore) {
    oh-my-posh init pwsh --config ~\.config\oh-my-posh\custom.omp.toml | Out-String | Invoke-Expression
}
