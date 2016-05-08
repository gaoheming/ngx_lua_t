file = io.input('aa.txt')

repeat
	line = io.read()
	if nil == line then
		break
	end
	--do
until (false)

io.close(file)



--
file=io.open('aa.txt','a+')
io.output(file)
io.write("helloe \r\n")
io.close(file)

--
file = io.open("test2.txt", "r")    -- 使用 io.open() 函数，以只读模式打开文件

for line in file:lines() do         -- 使用 file:lines() 函数逐行读取文件
   print(line)
end

file:close()


--

--https://moonbingbing.gitbooks.io/openresty-best-practices/content/lua/file.html
--
--
