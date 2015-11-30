CC=gcc
CFLAGS=-I/usr/include/gsl
LDFLAGS=-L/usr/local/lib
LIBS=-lgsl -lgslcblas

all: BIMH_forR

BIMH_forR: BIMH_forR.o distributions.o minimum.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o BIMH_forR BIMH_forR.o distributions.o minimum.o $(LIBS)

BIMH_forR.o: BIMH_forR.c distributions.h minimum.h
	$(CC) $(CFLAGS) -c BIMH_forR.c

distributions.o: distributions.c distributions.h
	$(CC) $(CFLAGS) -c distributions.c

minimum.o: minimum.c minimum.h
	$(CC) $(CFLAGS) -c minimum.c


