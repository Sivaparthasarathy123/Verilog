------------ FIFO TEST START --------------

--- WRITE DATA UNTIL FULL---
Time = 135000 | Write = 41 | Full = 0
Time = 145000 | Write = 42 | Full = 0
Time = 155000 | Write = 43 | Full = 0
Time = 165000 | Write = 44 | Full = 0
Time = 175000 | Write = 45 | Full = 0
Time = 185000 | Write = 46 | Full = 0
Time = 195000 | Write = 47 | Full = 0
Time = 205000 | Write = 48 | Full = 0
Time = 215000 | Write = 49 | Full = 1
FIFO IS FULL

--- READ DATA UNTIL EMPTY ---
Time = 231000 | Read = 41 | Empty = 0
Time = 251000 | Read = 42 | Empty = 0
Time = 271000 | Read = 43 | Empty = 0
Time = 291000 | Read = 44 | Empty = 0
Time = 311000 | Read = 45 | Empty = 0
Time = 331000 | Read = 46 | Empty = 0
Time = 351000 | Read = 47 | Empty = 0
Time = 371000 | Read = 48 | Empty = 1
FIFO IS EMPTY

---------- REPEAT TEST -------------
Write = 36
Write = 129
Read = 48
Write = 99

------- FIFO TEST DONE ------------
