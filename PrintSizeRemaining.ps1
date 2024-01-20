'空き容量は{0}GBです。' -f ((Get-Volume -DriveLetter C).SizeRemaining / 1GB)
