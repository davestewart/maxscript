start = timeStamp()
end = timeStamp()
rt = (end - start) / 1000.0


t = 7290							-- total time in seconds 1:01:30

s = mod t 60						-- seconds
t= (t-s)/60

m = mod t 60
t= (t-m)/60

h = mod t 60



format "%:%:%\n" h m s