(
-- variables
	local fileSrc="scriptFile.ms"
	local fileEnc="scriptFile.mse"
	local key=1234567890

-- encryption
	encryptFile fileSrc fileEnc key
	sleep 0.2
	
-- read unencrypted file
	fileIn fileSrc
	sleep 0.2
	
-- read encrypted file
	--fileIn fileEnc key:key

	f=openencryptedfile fileEnc key
	execute f
	close f

	/*
	while not eof f do format"%\n" (readline f)
	close f
	*/
)
