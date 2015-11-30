CC=gcc
CFLAGS=-I/usr/include/gsl
LDFLAGS=-L/usr/local/lib
LIBS=-lgsl -lgslcblas

all: BIMH

BIMH: BIMH.o distributions.o minimum.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o BIMH BIMH.o distributions.o minimum.o $(LIBS)

BIMH.o: BIMH.c distributions.h minimum.h
	$(CC) $(CFLAGS) -c BIMH.c

distributions.o: distributions.c distributions.h
	$(CC) $(CFLAGS) -c distributions.c

minimum.o: minimum.c minimum.h
	$(CC) $(CFLAGS) -c minimum.c


