CC		= g++
CFLAGS		= -g -Wall
TARGET		= todotxt
LIBS		= 
RM		= rm -f
DFLAGS		= -MM

SUBDIRS		:= $(shell ls -F | grep "\/" )
DIRS		:= ./ $(SUBDIRS)
SOURCES		:= $(foreach d, $(DIRS), $(wildcard $(d)*.cpp) )
OBJECTS		= $(patsubst %.cpp, %.o, $(SOURCES))
DEPENDENCIES	= $(patsubst %.cpp, %.d, $(SOURCES))

.PHONY		: dist clean run

%.d		: %.cpp
    $(CC) $(DFLAGS) $< -MT "$*.o $*.d" -MF $*.d

all		: $(DEPENDENCIES) $(TARGET)

$(TARGET)	: $(OBJECTS)
    $(CC) $(CFLAGS) -o $(TARGET) $(OBJECTS) $(LIBS)

ifneq "$(strip $(DEPENDENCIES))" ""
include $(DEPENDENCIES)
endif

%.o		: %.cpp
    $(CC) -c $(CFLAGS) -o $@ $<

clean		:
    $(RM) *.o
    $(RM) *.d
    $(RM) *.tar.gz

dist		: clean
    tar -cvzf $(TARGET).tar.gz *.cpp *.h README.md LICENSE $(TARGET)

run		: all clean
    ./$(TARGET)
