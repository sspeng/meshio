default: all

EXECS=test_mesh_io test_mesh_io_speed
CFLAGS=-O3 -Wall
# CFLAGS=-g
LIBS=
MPICC=mpicc
CC=gcc

# Blue Waters
ifeq "$(shell hostname | head -c 8)" "h2ologin"
CFLAGS=-O3
MPICC=cc
CC=cc
LIBS=-lrt

else

# Simple Linux node
MPICC=gcc
LIBS=-lmpi -lm
CFLAGS += -I/usr/include/mpich -L/usr/lib/mpich
# CFLAGS += -I/usr/local/mpich-3.2/include -L/usr/local/mpich-3.2/lib
# export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/mpich-3.2/lib
endif

all: $(EXECS)

reverse_bytes.o: reverse_bytes.c reverse_bytes.h
	$(MPICC) $(CFLAGS) -c $<

mesh_io.o: mesh_io.c mesh_io.h
	$(MPICC) $(CFLAGS) -c $<

test_mesh_io: test_mesh_io.c mesh_io.o reverse_bytes.o
	$(MPICC) $(CFLAGS) $^ $(LIBS) -o $@

test_mesh_io_speed: test_mesh_io_speed.c mesh_io.o reverse_bytes.o
	$(MPICC) $(CFLAGS) $^ $(LIBS) -o $@

clean:
	rm -f $(EXECS) *.o *~ test_mesh_io_speed.out
