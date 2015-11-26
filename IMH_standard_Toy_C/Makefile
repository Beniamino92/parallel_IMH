CC=gcc
CFLAGS=-I/usr/include/gsl
LDFLAGS=-L/usr/local/lib
LIBS=-lgsl -lgslcblas 

all: main

main: main.o minimum.o r_unif.o r_cauchy.o eval_weights.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o main main.o minimum.o r_unif.o r_cauchy.o eval_weights.o $(LIBS)

main.o: main.c minimum.h r_unif.h r_cauchy.h eval_weights.h
	$(CC) $(CFLAGS) -c main.c

minimum.o: minimum.c minimum.h r_unif.h r_cauchy.h eval_weights.h
	$(CC) $(CFLAGS) -c minimum.c

r_unif.o: r_unif.c r_unif.h r_cauchy.h eval_weights.h
	$(CC) $(CFLAGS) -c r_unif.c

r_cauchy.o: r_cauchy.c r_cauchy.h r_unif.h eval_weights.h
	$(CC) $(CFLAGS) -c r_cauchy.c

eval_weights.o: eval_weights.c eval_weights.h r_unif.h r_cauchy.h
	$(CC) $(CFLAGS) -c eval_weights.c


