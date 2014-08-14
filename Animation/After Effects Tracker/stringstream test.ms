(
t1 = timestamp()
local strstr = "" as stringstream
local str = "	1	10	20	30	\n"
for i = 1 to 10000 do format str to:strstr
t2 =  timestamp()
format "Time: %\n" (t2-t1)
)

(
t1 = timestamp()
local strstr = ""
local str = "	1	10	20	30	\n"
for i = 1 to 10000 do strstr += str
t2 =  timestamp()
format "Time: %\n" (t2-t1)
)

#(1,2,3) as string