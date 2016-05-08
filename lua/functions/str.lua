string.upper == strtoupper
string.lower ==strtolower
# == strlen
string.find(str,tofind) ==strpos
string.find  string.lower  == stripos
string.sub(str,1,4) ==substr
string.gsub(str,s,rep) == str_replace  s替换为rep
string.reverse  ==  strrev
tostring  ==stringval
tonumber  == intval
ngx.md5() == md5
string.rep(str,num)   strstrstr  num次

strrpos string.find  for string.sub

function strpos(str,f)
if str ~= nil and f ~= nil then
	return (string.find(str,f))
else 
	return nil
end
end

function strrpos (str, f)   
	if str ~= nil and f ~= nil then   
		local t = true  
		local offset = 1  
		local result = nil   
	while (t)   
	do  
		local tmp = string.find(str, f, offset)   
		if tmp ~= nil then   
		offset = offset + 1  
		result = tmp   
		else  
		t = false  
		end   
	end   
		return result   
	else  
		return nil   
	end   
end  


strrchr http://www.360doc.com/content/12/0523/17/1317564_213171441.shtml
