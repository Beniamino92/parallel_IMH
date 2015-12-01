CC=gcc
CFLAGS=-I/usr/include/gsl -fopenmp
LDFLAGS=-L/usr/local/lib
LIBS=-lgsl -lgslcblas

all: BIMH_forROpenMP2

BIMH_forROpenMP2: BIMH_forROpenMP2.o distributions.o minimum.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o BIMH_forROpenMP2 BIMH_forROpenMP2.o distributions.o minimum.o $(LIBS)

BIMH_forROpenMP2.o: BIMH_forROpenMP2.c distributions.h minimum.h
	$(CC) $(CFLAGS) -c BIMH_forROpenMP2.c

distributions.o: distributions.c distributions.h
	$(CC) $(CFLAGS) -c distributions.c

minimum.o: minimum.c minimum.h
	$(CC) $(CFLAGS) -c minimum.c


