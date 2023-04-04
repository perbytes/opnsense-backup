$apikey = ""
$apisecret = ""

# Enter your opnsense hostname and set the directory you would like to save the config to.
$hostname = ""
$backup_dir = "" # Example: C:\Users\JohnDoe\Documents

# Authentication header for the HTTP request
$auth_header = @{
    Authorization = "Basic $( [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("${apikey}:${apisecret}")) )"
}

$backup_file_name = "opnsense-config-$((Get-Date).ToString('yyyyMMdd-HHmmss')).xml" # You can change filename here. Default: opnsense-config-((date))-((time)).xml
$backup_url = "https://$hostname/api/backup/backup/download"
$backup_file_path = Join-Path -Path $backup_dir -ChildPath $backup_file_name

Invoke-WebRequest -Uri $backup_url -Headers $auth_header -OutFile $backup_file_path


# You can change the retention period to suit your needs below. Default: 30 days.

$old_backups = Get-ChildItem -Path $backup_dir -Filter *.xml | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) }
$old_backups | Remove-Item -Force
