.PHONY: all volume1 volume2 clean

all: volume1 volume2

volume1:
	$(MAKE) -C volume1 all

volume2:
	$(MAKE) -C volume2 all

clean:
	$(MAKE) -C volume1 clean
	$(MAKE) -C volume2 clean
