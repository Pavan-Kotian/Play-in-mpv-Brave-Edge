$mpv = "C:\Users\pavan\AppData\Roaming\mpv\mpv.exe"
$ytDlp = (Get-Command yt-dlp.exe -ErrorAction SilentlyContinue).Source

function Read-NativeMessage {
    $lengthBytes = New-Object byte[] 4
    $read = [Console]::OpenStandardInput().Read($lengthBytes, 0, 4)
    if ($read -ne 4) { return $null }
    $length = [BitConverter]::ToInt32($lengthBytes, 0)
    if ($length -le 0 -or $length -gt 10MB) { return $null }
    $bytes = New-Object byte[] $length
    $offset = 0
    while ($offset -lt $length) {
        $n = [Console]::OpenStandardInput().Read($bytes, $offset, $length - $offset)
        if ($n -le 0) { return $null }
        $offset += $n
    }
    return [Text.Encoding]::UTF8.GetString($bytes)
}

while ($true) {
    $json = Read-NativeMessage
    if ($null -eq $json) { break }
    try {
        $msg = $json | ConvertFrom-Json
        $url = [string]$msg.url
        if ($url -and (Test-Path $mpv)) {
            if ($ytDlp) {
                Start-Process -FilePath $mpv -ArgumentList @("--script-opts=ytdl_hook-ytdl_path=$ytDlp", $url)
            } else {
                Start-Process -FilePath $mpv -ArgumentList @($url)
            }
        }
    } catch {
        # Ignore malformed messages so the native host remains alive.
    }
}