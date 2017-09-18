If (-Not (Test-Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent)) {
    New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows -Name CloudContent
}

Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent -Name DisableWindowsConsumerFeatures -Value 1 -Type DWord