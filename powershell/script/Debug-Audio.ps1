[System.Console]::Beep(200,1000)
[System.Console]::Beep(600,1000)

[System.Media.SystemSounds]::Exclamation.Play()
[System.Media.SystemSounds]::Hand.Play()

$player = New-Object System.Media.SoundPlayer "$env:windir  \Media\windows logon.wav"
$player.PlayLooping()
$player.Stop()
