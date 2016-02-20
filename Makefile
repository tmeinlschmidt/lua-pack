PKG=lua
# change these to reflect your Lua installation
LUA_LIB=`pkg-config lua --libs`
LUA_BIN=`pkg-config lua --variable=INSTALL_BIN`

# probably no need to change anything below here
WARN= -O2 -Wall -fPIC -W -Waggregate-return -Wcast-align -Wmissing-prototypes -Wnested-externs -Wshadow -Wwrite-strings -pedantic
CFLAGS=`pkg-config lua --cflags`
CFLAGS+= $(WARN)
LDFLAGS=$(LUA_LIB)
#LDFLAGS+=-shared # for linux
LDFLAGS+=-bundle -undefined dynamic_lookup # for MacOS X

MYNAME= pack
MYLIB= l$(MYNAME)
T= $(MYNAME).so
OBJS= $(MYLIB).o
TEST= test.lua

all:	test

test:	$T
	$(LUA_BIN)/lua $(TEST)

o:	$(MYLIB).o

so:	$T

$T:	$(OBJS)
	MACOSX_DEPLOYMENT_TARGET="10.11"; export MACOSX_DEPLOYMENT_TARGET; $(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJS)

clean:
	rm -f $(OBJS) $T core core.* a.out

doc:
	@echo "$(MYNAME) library:"
	@fgrep '/**' $(MYLIB).c | cut -f2 -d/ | tr -d '*' | sort | column

# distribution

FTP= $(HOME)/public/ftp/lua/5.1
D= $(MYNAME)
A= $(MYLIB).tar.gz
TOTAR= Makefile,README,$(MYLIB).c,test.lua

tar:	clean
	tar zcvf $A -C .. $D/{$(TOTAR)}

distr:	tar
	touch -r $A .stamp
	mv $A $(FTP)

diff:	clean
	tar zxf $(FTP)/$A
	diff $D .

# eof
