--------- FIFO TEST STARTED ---------

--- Writing values ---
Time = 25000 data = 10, full = 0, empty = 1
Time = 35000 data = 20, full = 0, empty = 0
Time = 45000 data = 30, full = 0, empty = 0
Time = 55000 data = 40, full = 0, empty = 0

--- Reading values ---
Time = 66000 data = 10, full = 0, empty = 0
Time = 76000 data = 20, full = 0, empty = 0
Time = 86000 data = 30, full = 0, empty = 0
Time = 96000 data = 40, full = 0, empty = 1

------------- Fill FIFO --------------
data = 101, full = 0, empty = 1
data = 102, full = 0, empty = 0
data = 103, full = 0, empty = 0
data = 104, full = 0, empty = 0
data = 105, full = 0, empty = 0
data = 106, full = 0, empty = 0
data = 107, full = 0, empty = 0
data = 108, full = 1, empty = 0
----------- FIFO FULL -> 1  ---------

----------- Empty FIFO --------------
data = 101, full = 0, empty = 0
data = 102, full = 0, empty = 0
data = 103, full = 0, empty = 0
data = 104, full = 0, empty = 0
data = 105, full = 0, empty = 0
data = 106, full = 0, empty = 0
data = 107, full = 0, empty = 0
data = 108, full = 0, empty = 1
------------- FIFO EMPTY -> 1 ---------

----------- WRITE & READ -----------
WRITE: 200
WRITE -> 44
READ -> 108
------- FIFO TEST COMPLETED -----------
