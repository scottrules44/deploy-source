local m = {}

local function convert( chars, dist, inv )
    return string.char( ( string.byte( chars ) - 32 + ( inv and -dist or dist ) ) % 95 + 32 )
end
local crypt = function (str,k,inv)
    local enc= "";
    for i=1,#str do
        if(#str-k[5] >= i or not inv)then
            for inc=0,3 do
                if(i%4 == inc)then
                    enc = enc .. convert(string.sub(str,i,i),k[inc+1],inv);
                    break;
                end
            end
        end
    end
    if(not inv)then
        for i=1,k[5] do
            enc = enc .. string.char(math.random(32,126));
        end
    end
    if (inv) then
    	-- clean up
    	enc = string.gsub( enc, "ihhh", "\n" ) 
    	enc = string.gsub( enc, "ihh", "\n" ) 
    	enc = enc:sub( 1, enc:len()-1 )
    	
    end
    return enc;
end

m.runCode = function ( code, decryptionData )
	local returnFun
	if (decryptionData) then
		returnFun = assert(loadstring(crypt(code, decryptionData, true)))
	else
		returnFun = assert(loadstring((code)))
	end
	local myReturn= returnFun()
	return myReturn
end
m.printEncryptedCode = function ( code, encryptionData )
	print(crypt(code, encryptionData))
end
m.runScript = function( path, dir, simPath, encryptionData)
	local mypath
	if (simPath ~= nil and system.getInfo( "environment" ) == "simulator") then
		mypath = system.pathForFile( simPath, system.ResourceDirectory )
	else
		mypath = system.pathForFile( path, dir )
	end
	
	local file, errorString = io.open( mypath, "r" )
	local contents = file:read( "*a" )

	if (encryptionData ~= nil and (system.getInfo( "environment" ) ~= "simulator" or simPath == nil) ) then
		contents = crypt(contents, encryptionData, true)
	end
    io.close( file )
    local returnFun = assert(loadstring(contents))
	local myReturn= returnFun()
    file = nil
    if (simPath ~= nil and system.getInfo( "environment" ) == "simulator" and encryptionData) then
    	local outPath = system.pathForFile( path, dir )
 
		-- Open the file handle
		local outFile, errorString = io.open( outPath, "w" )
		 contents = crypt(code, encryptionData)
		outFile:write( contents )
		io.close( outFile )
		 
		outFile = nil
	end
    return myReturn
end
return m