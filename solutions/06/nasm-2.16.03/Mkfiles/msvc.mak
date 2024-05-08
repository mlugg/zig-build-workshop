# -*- makefile -*-
#
# Makefile for building NASM using Microsoft Visual C++ and NMAKE.
# Tested on Microsoft Visual C++ 2005 Express Edition.
#
# Make sure to put the appropriate directories in your PATH, in
# the case of MSVC++ 2005, they are ...\VC\bin and ...\Common7\IDE.
#
# This is typically done by opening the Visual Studio Command Prompt.
#

top_srcdir	= .
srcdir		= .
objdir          = .
VPATH		= .
prefix		= "C:\Program Files\NASM"
exec_prefix	= $(prefix)
bindir		= $(prefix)/bin
mandir		= $(prefix)/man

MANIFEST_FLAGS  = /MANIFEST:EMBED /MANIFESTFILE:$(MANIFEST)

!IF "$(DEBUG)" == "1"
CFLAGS		= /Od /Zi
LDFLAGS		= /DEBUG
!ELSE
CFLAGS		= /O2 /Zi
 # /OPT:REF and /OPT:ICF two undo /DEBUG harm
LDFLAGS		= /DEBUG /OPT:REF /OPT:ICF
!ENDIF

CC		= cl
AR		= lib
BUILD_CFLAGS	= $(CFLAGS) /W2
INTERNAL_CFLAGS = /I$(srcdir) /I. \
		  /I$(srcdir)/include /I./include \
		  /I$(srcdir)/x86 /I./x86 \
		  /I$(srcdir)/asm /I./asm \
		  /I$(srcdir)/disasm /I./disasm \
		  /I$(srcdir)/output /I./output
ALL_CFLAGS	= $(BUILD_CFLAGS) $(INTERNAL_CFLAGS)
MANIFEST_FLAGS  = /MANIFEST:EMBED /MANIFESTINPUT:$(MANIFEST)
ALL_LDFLAGS	= /link $(LDFLAGS) $(MANIFEST_FLAGS) /SUBSYSTEM:CONSOLE /RELEASE
LIBS		=

PERL		= perl
PERLFLAGS	= -I$(srcdir)/perllib -I$(srcdir)
RUNPERL         = $(PERL) $(PERLFLAGS)

MAKENSIS        = makensis

RM_F		= -del /f
LN_S		= copy

# Binary suffixes
O               = obj
A		= lib
X               = .exe
.SUFFIXES:
.SUFFIXES: $(X) .$(A) .obj .c .i .s .1 .man

.c.obj:
	$(CC) /c $(ALL_CFLAGS) /Fo$@ $<

MANIFEST = win/manifest.xml

#-- Begin File Lists --#
# Edit in Makefile.in, not here!
NASM    = asm\nasm.obj
NDISASM = disasm\ndisasm.obj

PROGOBJ = $(NASM) $(NDISASM)
PROGS   = nasm$(X) ndisasm$(X)

LIBOBJ_NW = stdlib\snprintf.obj stdlib\vsnprintf.obj stdlib\strlcpy.obj \
	stdlib\strnlen.obj stdlib\strrchrnul.obj \
	\
	nasmlib\ver.obj \
	nasmlib\alloc.obj nasmlib\asprintf.obj nasmlib\errfile.obj \
	nasmlib\crc32.obj nasmlib\crc64.obj nasmlib\md5c.obj \
	nasmlib\string.obj nasmlib\nctype.obj \
	nasmlib\file.obj nasmlib\mmap.obj nasmlib\ilog2.obj \
	nasmlib\realpath.obj nasmlib\path.obj \
	nasmlib\filename.obj nasmlib\rlimit.obj \
	nasmlib\readnum.obj nasmlib\numstr.obj \
	nasmlib\zerobuf.obj nasmlib\bsi.obj \
	nasmlib\rbtree.obj nasmlib\hashtbl.obj \
	nasmlib\raa.obj nasmlib\saa.obj \
	nasmlib\strlist.obj \
	nasmlib\perfhash.obj nasmlib\badenum.obj \
	\
	common\common.obj \
	\
	x86\insnsa.obj x86\insnsb.obj x86\insnsd.obj x86\insnsn.obj \
	x86\regs.obj x86\regvals.obj x86\regflags.obj x86\regdis.obj \
	x86\disp8.obj x86\iflag.obj \
	\
	asm\error.obj \
	asm\floats.obj \
	asm\directiv.obj asm\directbl.obj \
	asm\pragma.obj \
	asm\assemble.obj asm\labels.obj asm\parser.obj \
	asm\preproc.obj asm\quote.obj asm\pptok.obj \
	asm\listing.obj asm\eval.obj asm\exprlib.obj asm\exprdump.obj \
	asm\stdscan.obj \
	asm\strfunc.obj asm\tokhash.obj \
	asm\segalloc.obj \
	asm\rdstrnum.obj \
	asm\srcfile.obj \
	macros\macros.obj \
	\
	output\outform.obj output\outlib.obj output\legacy.obj \
	output\nulldbg.obj output\nullout.obj \
	output\outbin.obj output\outaout.obj output\outcoff.obj \
	output\outelf.obj \
	output\outobj.obj output\outas86.obj \
	output\outdbg.obj output\outieee.obj output\outmacho.obj \
	output\codeview.obj \
	\
	disasm\disasm.obj disasm\sync.obj

# Warnings depend on all source files, so handle them separately
WARNOBJ   = asm\warnings.obj
WARNFILES = asm\warnings_c.h include\warnings.h doc\warnings.src

LIBOBJ    = $(LIBOBJ_NW) $(WARNOBJ)
ALLOBJ_NW = $(PROGOBJ) $(LIBOBJ_NW)
ALLOBJ    = $(PROGOBJ) $(LIBOBJ)

SUBDIRS  = stdlib nasmlib include config output asm disasm x86 \
	   common macros
XSUBDIRS = test doc nsis win
DEPDIRS  = . $(SUBDIRS)
#-- End File Lists --#

NASMLIB = libnasm.$(A)

all: nasm$(X) ndisasm$(X)

nasm$(X): $(NASM) $(MANIFEST) $(NASMLIB)
	$(CC) /Fe$@ $(NASM) $(ALL_LDFLAGS) $(NASMLIB) $(LIBS)

ndisasm$(X): $(NDISASM) $(MANIFEST) $(NASMLIB)
	$(CC) /Fe$@ $(NDISASM) $(ALL_LDFLAGS) $(NASMLIB) $(LIBS)

$(NASMLIB): $(LIBOBJ)
	$(AR) $(ARFLAGS) /OUT:$@ $**

# These are specific to certain Makefile syntaxes...
WARNTIMES = $(patsubst %,%.time,$(WARNFILES))
WARNSRCS  = $(patsubst %.obj,%.c,$(LIBOBJ_NW))

#-- Begin Generated File Rules --#
# Edit in Makefile.in, not here!

# These source files are automagically generated from data files using
# Perl scripts. They're distributed, though, so it isn't necessary to
# have Perl just to recompile NASM from the distribution.

# Perl-generated source files
PERLREQ_CLEANABLE = \
	  x86\insnsb.c x86\insnsa.c x86\insnsd.c x86\insnsi.h x86\insnsn.c \
	  x86\regs.c x86\regs.h x86\regflags.c x86\regdis.c x86\regdis.h \
	  x86\regvals.c asm\tokhash.c asm\tokens.h asm\pptok.h asm\pptok.c \
	  x86\iflag.c x86\iflaggen.h \
	  macros\macros.c \
	  asm\pptok.ph asm\directbl.c asm\directiv.h \
	  $(WARNFILES) \
	  misc\nasmtok.el \
	  version.h version.mac version.mak nsis\version.nsh

# Special hack to keep config\unconfig.h from getting deleted
# by "make spotless"...
PERLREQ = config\unconfig.h $(PERLREQ_CLEANABLE)

INSDEP = x86\insns.dat x86\insns.pl x86\insns-iflags.ph x86\iflags.ph

config\unconfig.h: config\config.h.in autoconf\unconfig.pl
	$(RUNPERL) '$(srcdir)'\autoconf\unconfig.pl \
		'$(srcdir)' config\config.h.in config\unconfig.h

x86\iflag.c: $(INSDEP)
	$(RUNPERL) $(srcdir)\x86\insns.pl -fc \
		$(srcdir)\x86\insns.dat x86\iflag.c
x86\iflaggen.h: $(INSDEP)
	$(RUNPERL) $(srcdir)\x86\insns.pl -fh \
		$(srcdir)\x86\insns.dat x86\iflaggen.h
x86\insnsb.c: $(INSDEP)
	$(RUNPERL) $(srcdir)\x86\insns.pl -b \
		$(srcdir)\x86\insns.dat x86\insnsb.c
x86\insnsa.c: $(INSDEP)
	$(RUNPERL) $(srcdir)\x86\insns.pl -a \
		$(srcdir)\x86\insns.dat x86\insnsa.c
x86\insnsd.c: $(INSDEP)
	$(RUNPERL) $(srcdir)\x86\insns.pl -d \
		$(srcdir)\x86\insns.dat x86\insnsd.c
x86\insnsi.h: $(INSDEP)
	$(RUNPERL) $(srcdir)\x86\insns.pl -i \
		$(srcdir)\x86\insns.dat x86\insnsi.h
x86\insnsn.c: $(INSDEP)
	$(RUNPERL) $(srcdir)\x86\insns.pl -n \
		$(srcdir)\x86\insns.dat x86\insnsn.c

# These files contains all the standard macros that are derived from
# the version number.
version.h: version version.pl
	$(RUNPERL) $(srcdir)\version.pl h < $(srcdir)\version > version.h
version.mac: version version.pl
	$(RUNPERL) $(srcdir)\version.pl mac < $(srcdir)\version > version.mac
version.sed: version version.pl
	$(RUNPERL) $(srcdir)\version.pl sed < $(srcdir)\version > version.sed
version.mak: version version.pl
	$(RUNPERL) $(srcdir)\version.pl make < $(srcdir)\version > version.mak
nsis\version.nsh: version version.pl
	$(RUNPERL) $(srcdir)\version.pl nsis < $(srcdir)\version > nsis\version.nsh

# This source file is generated from the standard macros file
# `standard.mac' by another Perl script. Again, it's part of the
# standard distribution.
macros\macros.c: macros\macros.pl asm\pptok.ph version.mac \
	$(srcdir)\macros\*.mac $(srcdir)\output\*.mac
	$(RUNPERL) $(srcdir)\macros\macros.pl version.mac \
		$(srcdir)\macros\*.mac $(srcdir)\output\*.mac

# These source files are generated from regs.dat by yet another
# perl script.
x86\regs.c: x86\regs.dat x86\regs.pl
	$(RUNPERL) $(srcdir)\x86\regs.pl c \
		$(srcdir)\x86\regs.dat > x86\regs.c
x86\regflags.c: x86\regs.dat x86\regs.pl
	$(RUNPERL) $(srcdir)\x86\regs.pl fc \
		$(srcdir)\x86\regs.dat > x86\regflags.c
x86\regdis.c: x86\regs.dat x86\regs.pl
	$(RUNPERL) $(srcdir)\x86\regs.pl dc \
		$(srcdir)\x86\regs.dat > x86\regdis.c
x86\regdis.h: x86\regs.dat x86\regs.pl
	$(RUNPERL) $(srcdir)\x86\regs.pl dh \
		$(srcdir)\x86\regs.dat > x86\regdis.h
x86\regvals.c: x86\regs.dat x86\regs.pl
	$(RUNPERL) $(srcdir)\x86\regs.pl vc \
		$(srcdir)\x86\regs.dat > x86\regvals.c
x86\regs.h: x86\regs.dat x86\regs.pl
	$(RUNPERL) $(srcdir)\x86\regs.pl h \
		$(srcdir)\x86\regs.dat > x86\regs.h

# Extract warnings from source code. This is done automatically if any
# C files have changed; the script is fast enough that that is
# reasonable, but doesn't update the time stamp if the files aren't
# changed, to avoid rebuilding everything every time. Track the actual
# dependency by the empty file asm\warnings.time.
.PHONY: warnings
warnings: dirs
	$(RM_F) $(WARNFILES) $(WARNTIMES) asm\warnings.time
	$(MAKE) asm\warnings.time

asm\warnings.time: $(WARNSRCS) asm\warnings.pl
	$(EMPTY) asm\warnings.time
	$(MAKE) $(WARNTIMES)

asm\warnings_c.h.time: asm\warnings.pl asm\warnings.time
	$(RUNPERL) $(srcdir)\asm\warnings.pl c asm\warnings_c.h $(srcdir)
	$(EMPTY) asm\warnings_c.h.time

asm\warnings_c.h: asm\warnings_c.h.time
	@: Side effect

include\warnings.h.time: asm\warnings.pl asm\warnings.time
	$(RUNPERL) $(srcdir)\asm\warnings.pl h include\warnings.h $(srcdir)
	$(EMPTY) include\warnings.h.time

include\warnings.h: include\warnings.h.time
	@: Side effect

doc\warnings.src.time: asm\warnings.pl asm\warnings.time
	$(RUNPERL) $(srcdir)\asm\warnings.pl doc doc\warnings.src $(srcdir)
	$(EMPTY) doc\warnings.src.time

doc\warnings.src : doc\warnings.src.time
	@: Side effect

# Assembler token hash
asm\tokhash.c: x86\insns.dat x86\insnsn.c asm\tokens.dat asm\tokhash.pl \
	perllib\phash.ph
	$(RUNPERL) $(srcdir)\asm\tokhash.pl c \
		x86\insnsn.c $(srcdir)\x86\regs.dat \
		$(srcdir)\asm\tokens.dat > asm\tokhash.c

# Assembler token metadata
asm\tokens.h: x86\insns.dat x86\insnsn.c asm\tokens.dat asm\tokhash.pl \
	perllib\phash.ph
	$(RUNPERL) $(srcdir)\asm\tokhash.pl h \
		x86\insnsn.c $(srcdir)\x86\regs.dat \
		$(srcdir)\asm\tokens.dat > asm\tokens.h

# Preprocessor token hash
asm\pptok.h: asm\pptok.dat asm\pptok.pl perllib\phash.ph
	$(RUNPERL) $(srcdir)\asm\pptok.pl h \
		$(srcdir)\asm\pptok.dat asm\pptok.h
asm\pptok.c: asm\pptok.dat asm\pptok.pl perllib\phash.ph
	$(RUNPERL) $(srcdir)\asm\pptok.pl c \
		$(srcdir)\asm\pptok.dat asm\pptok.c
asm\pptok.ph: asm\pptok.dat asm\pptok.pl perllib\phash.ph
	$(RUNPERL) $(srcdir)\asm\pptok.pl ph \
		$(srcdir)\asm\pptok.dat asm\pptok.ph

# Directives hash
asm\directiv.h: asm\directiv.dat nasmlib\perfhash.pl perllib\phash.ph
	$(RUNPERL) $(srcdir)\nasmlib\perfhash.pl h \
		$(srcdir)\asm\directiv.dat asm\directiv.h
asm\directbl.c: asm\directiv.dat nasmlib\perfhash.pl perllib\phash.ph
	$(RUNPERL) $(srcdir)\nasmlib\perfhash.pl c \
		$(srcdir)\asm\directiv.dat asm\directbl.c

# Emacs token files
misc\nasmtok.el: misc\emacstbl.pl asm\tokhash.c asm\pptok.c \
		 asm\directiv.dat version
	$(RUNPERL) $< $@ "$(srcdir)" "$(objdir)"

#-- End Generated File Rules --#

perlreq: $(PERLREQ)

#-- Begin NSIS Rules --#
# Edit in Makefile.in, not here!

nsis\arch.nsh: nsis\getpearch.pl nasm$(X)
	$(PERL) $(srcdir)\nsis\getpearch.pl nasm$(X) > nsis\arch.nsh

# Should only be done after "make everything".
# The use of redirection here keeps makensis from moving the cwd to the
# source directory.
nsis: nsis\nasm.nsi nsis\arch.nsh nsis\version.nsh
	$(MAKENSIS) -Dsrcdir="$(srcdir)" -Dobjdir="$(objdir)" - < nsis\nasm.nsi

#-- End NSIS Rules --#

clean:
	-del /f /s *.obj
	-del /f /s *.pdb
	-del /f /s *.s
	-del /f /s *.i
	-del /f $(NASMLIB) $(RDFLIB)
	-del /f nasm$(X)
	-del /f ndisasm$(X)

distclean: clean
	-del /f config.h
	-del /f config.log
	-del /f config.status
	-del /f Makefile
	-del /f /s *~
	-del /f /s *.bak
	-del /f /s *.lst
	-del /f /s *.bin
	-del /f /s *.dep
	-del /f output\*~
	-del /f output\*.bak
	-del /f test\*.lst
	-del /f test\*.bin
	-del /f test\*.obj
	-del /f test\*.bin
	-del /f/s autom4te*.cache

cleaner: clean
	-del /f $(PERLREQ)
	-del /f *.man
	-del /f nasm.spec
	rem cd doc && $(MAKE) clean

spotless: distclean cleaner
	-del /f doc\Makefile
	-del doc\*~
	-del doc\*.bak

strip:

# Abuse doc/Makefile.in to build nasmdoc.pdf only
docs:
	cd doc && $(MAKE) /f Makefile.in srcdir=. top_srcdir=.. \
		PERL=$(PERL) PDFOPT= nasmdoc.pdf

everything: all docs nsis

#
# Does this version of this file have external dependencies?  This definition
# will be automatically updated by mkdep.pl as needed.
#
EXTERNAL_DEPENDENCIES = 0

#
# Generate dependency information for this Makefile only.
# If this Makefile has external dependency information, then
# the dependency information will remain external, so it doesn't
# pollute the git logs.
#
msvc.dep: $(PERLREQ) tools\mkdep.pl
	$(RUNPERL) tools\mkdep.pl -M Mkfiles\msvc.mak -- $(DEPDIRS)

dep: msvc.dep

# Include and/or generate msvc.dep as needed. This is too complex to
# use the include-command feature, but we can open-code it here.
MKDEP=0
!IF $(EXTERNAL_DEPENDENCIES) == 1 && $(MKDEP) == 0
!IF EXISTS(msvc.dep)
!INCLUDE msvc.dep
!ELSEIF [$(MAKE) /c MKDEP=1 /f Mkfiles\msvc.mak msvc.dep] == 0
!INCLUDE msvc.dep
!ELSE
!ERROR Unable to rebuild dependencies file msvc.dep
!ENDIF
!ENDIF

#-- Magic hints to mkdep.pl --#
# @object-ending: ".obj"
# @path-separator: "\"
# @exclude: "config/config.h"
# @external: "msvc.dep"
# @selfrule: "1"
#-- Everything below is generated by mkdep.pl - do not edit --#
asm\assemble.obj: asm\assemble.c asm\assemble.h asm\listing.h \
 include\compiler.h include\dbginfo.h include\disp8.h include\error.h \
 include\insns.h include\nasm.h include\nasmlib.h include\tables.h
asm\directbl.obj: asm\directbl.c asm\directiv.h
asm\directiv.obj: asm\directiv.c asm\assemble.h asm\eval.h asm\floats.h \
 asm\listing.h asm\preproc.h asm\stdscan.h include\compiler.h \
 include\error.h include\iflag.h include\ilog2.h include\labels.h \
 include\nasm.h include\nasmlib.h include\nctype.h output\outform.h
asm\error.obj: asm\error.c include\compiler.h include\error.h \
 include\nasmlib.h
asm\eval.obj: asm\eval.c asm\assemble.h asm\eval.h asm\floats.h \
 include\compiler.h include\error.h include\ilog2.h include\labels.h \
 include\nasm.h include\nasmlib.h include\nctype.h
asm\exprdump.obj: asm\exprdump.c include\nasm.h
asm\exprlib.obj: asm\exprlib.c include\nasm.h
asm\floats.obj: asm\floats.c asm\floats.h include\compiler.h include\error.h \
 include\nasm.h include\nctype.h
asm\labels.obj: asm\labels.c include\compiler.h include\error.h \
 include\hashtbl.h include\labels.h include\nasm.h include\nasmlib.h
asm\listing.obj: asm\listing.c asm\listing.h include\compiler.h \
 include\error.h include\nasm.h include\nasmlib.h include\nctype.h \
 include\strlist.h
asm\nasm.obj: asm\nasm.c asm\assemble.h asm\eval.h asm\floats.h \
 asm\listing.h asm\parser.h asm\preproc.h asm\quote.h asm\stdscan.h \
 include\compiler.h include\error.h include\iflag.h include\insns.h \
 include\labels.h include\nasm.h include\nasmlib.h include\nctype.h \
 include\raa.h include\saa.h include\ver.h output\outform.h
asm\parser.obj: asm\parser.c asm\assemble.h asm\eval.h asm\floats.h \
 asm\parser.h asm\stdscan.h include\compiler.h include\error.h \
 include\insns.h include\nasm.h include\nasmlib.h include\nctype.h \
 include\tables.h
asm\pptok.obj: asm\pptok.c asm\preproc.h include\compiler.h \
 include\hashtbl.h include\nasmlib.h include\nctype.h
asm\pragma.obj: asm\pragma.c asm\assemble.h asm\listing.h include\compiler.h \
 include\error.h include\nasm.h include\nasmlib.h include\nctype.h
asm\preproc.obj: asm\preproc.c asm\eval.h asm\listing.h asm\preproc.h \
 asm\quote.h asm\stdscan.h asm\tokens.h include\compiler.h include\dbginfo.h \
 include\error.h include\hashtbl.h include\nasm.h include\nasmlib.h \
 include\nctype.h include\tables.h
asm\quote.obj: asm\quote.c asm\quote.h include\compiler.h include\error.h \
 include\nasmlib.h include\nctype.h
asm\rdstrnum.obj: asm\rdstrnum.c include\compiler.h include\nasm.h \
 include\nasmlib.h
asm\segalloc.obj: asm\segalloc.c include\compiler.h include\insns.h \
 include\nasm.h include\nasmlib.h
asm\srcfile.obj: asm\srcfile.c asm\srcfile.h include\compiler.h \
 include\hashtbl.h include\nasmlib.h
asm\stdscan.obj: asm\stdscan.c asm\quote.h asm\stdscan.h include\compiler.h \
 include\error.h include\insns.h include\nasm.h include\nasmlib.h \
 include\nctype.h
asm\strfunc.obj: asm\strfunc.c include\nasm.h include\nasmlib.h
asm\tokhash.obj: asm\tokhash.c asm\stdscan.h include\compiler.h \
 include\hashtbl.h include\insns.h include\nasm.h
asm\warnings.obj: asm\warnings.c asm\warnings_c.h
common\common.obj: common\common.c include\compiler.h include\insns.h \
 include\nasm.h include\nasmlib.h
disasm\disasm.obj: disasm\disasm.c disasm\disasm.h disasm\sync.h \
 include\compiler.h include\disp8.h include\insns.h include\nasm.h \
 include\tables.h x86\regdis.h
disasm\ndisasm.obj: disasm\ndisasm.c disasm\disasm.h disasm\sync.h \
 include\compiler.h include\error.h include\insns.h include\nasm.h \
 include\nasmlib.h include\nctype.h include\ver.h
disasm\sync.obj: disasm\sync.c disasm\sync.h include\compiler.h \
 include\nasmlib.h
macros\macros.obj: macros\macros.c include\hashtbl.h include\nasmlib.h \
 include\tables.h output\outform.h
nasmlib\alloc.obj: nasmlib\alloc.c include\compiler.h include\error.h \
 include\nasmlib.h nasmlib\alloc.h
nasmlib\asprintf.obj: nasmlib\asprintf.c include\compiler.h \
 include\nasmlib.h nasmlib\alloc.h
nasmlib\badenum.obj: nasmlib\badenum.c include\nasmlib.h
nasmlib\bsi.obj: nasmlib\bsi.c include\compiler.h include\nasmlib.h
nasmlib\crc32.obj: nasmlib\crc32.c include\compiler.h include\hashtbl.h
nasmlib\crc64.obj: nasmlib\crc64.c include\compiler.h include\hashtbl.h \
 include\nctype.h
nasmlib\errfile.obj: nasmlib\errfile.c include\compiler.h
nasmlib\file.obj: nasmlib\file.c nasmlib\file.h
nasmlib\filename.obj: nasmlib\filename.c include\compiler.h include\error.h \
 include\nasmlib.h
nasmlib\hashtbl.obj: nasmlib\hashtbl.c include\compiler.h include\hashtbl.h \
 include\nasm.h
nasmlib\ilog2.obj: nasmlib\ilog2.c include\ilog2.h
nasmlib\md5c.obj: nasmlib\md5c.c include\md5.h
nasmlib\mmap.obj: nasmlib\mmap.c nasmlib\file.h
nasmlib\nctype.obj: nasmlib\nctype.c include\nctype.h
nasmlib\numstr.obj: nasmlib\numstr.c include\nasmlib.h
nasmlib\path.obj: nasmlib\path.c include\compiler.h include\error.h \
 include\nasmlib.h
nasmlib\perfhash.obj: nasmlib\perfhash.c include\hashtbl.h \
 include\perfhash.h
nasmlib\raa.obj: nasmlib\raa.c include\ilog2.h include\nasmlib.h \
 include\raa.h
nasmlib\rbtree.obj: nasmlib\rbtree.c include\nasmlib.h include\rbtree.h
nasmlib\readnum.obj: nasmlib\readnum.c include\compiler.h include\error.h \
 include\nasm.h include\nasmlib.h include\nctype.h
nasmlib\realpath.obj: nasmlib\realpath.c include\compiler.h \
 include\nasmlib.h
nasmlib\rlimit.obj: nasmlib\rlimit.c include\compiler.h include\nasmlib.h
nasmlib\saa.obj: nasmlib\saa.c include\compiler.h include\nasmlib.h \
 include\saa.h
nasmlib\string.obj: nasmlib\string.c include\compiler.h include\nasmlib.h \
 include\nctype.h
nasmlib\strlist.obj: nasmlib\strlist.c include\strlist.h
nasmlib\ver.obj: nasmlib\ver.c include\ver.h version.h
nasmlib\zerobuf.obj: nasmlib\zerobuf.c include\compiler.h include\nasmlib.h
output\codeview.obj: output\codeview.c asm\preproc.h include\compiler.h \
 include\error.h include\hashtbl.h include\md5.h include\nasm.h \
 include\nasmlib.h include\saa.h output\outlib.h output\pecoff.h version.h
output\legacy.obj: output\legacy.c include\nasm.h output\outlib.h
output\nulldbg.obj: output\nulldbg.c include\nasm.h include\nasmlib.h \
 output\outlib.h
output\nullout.obj: output\nullout.c include\nasm.h include\nasmlib.h \
 output\outlib.h
output\outaout.obj: output\outaout.c asm\eval.h asm\stdscan.h \
 include\compiler.h include\error.h include\nasm.h include\nasmlib.h \
 include\nctype.h include\raa.h include\saa.h output\outform.h \
 output\outlib.h
output\outas86.obj: output\outas86.c include\compiler.h include\error.h \
 include\nasm.h include\nasmlib.h include\nctype.h include\raa.h \
 include\saa.h output\outform.h output\outlib.h
output\outbin.obj: output\outbin.c asm\eval.h asm\stdscan.h \
 include\compiler.h include\error.h include\labels.h include\nasm.h \
 include\nasmlib.h include\nctype.h include\saa.h output\outform.h \
 output\outlib.h
output\outcoff.obj: output\outcoff.c asm\eval.h include\compiler.h \
 include\error.h include\ilog2.h include\nasm.h include\nasmlib.h \
 include\nctype.h include\raa.h include\saa.h include\ver.h output\outform.h \
 output\outlib.h output\pecoff.h
output\outdbg.obj: output\outdbg.c include\compiler.h include\dbginfo.h \
 include\insns.h include\nasm.h include\nasmlib.h include\nctype.h \
 output\outform.h output\outlib.h
output\outelf.obj: output\outelf.c asm\eval.h asm\stdscan.h \
 include\compiler.h include\error.h include\hashtbl.h include\nasm.h \
 include\nasmlib.h include\raa.h include\rbtree.h include\saa.h \
 include\ver.h output\dwarf.h output\elf.h output\outelf.h output\outform.h \
 output\outlib.h output\stabs.h
output\outform.obj: output\outform.c include\compiler.h output\outform.h \
 output\outlib.h
output\outieee.obj: output\outieee.c include\compiler.h include\error.h \
 include\nasm.h include\nasmlib.h include\nctype.h include\ver.h \
 output\outform.h output\outlib.h
output\outlib.obj: output\outlib.c include\raa.h output\outlib.h
output\outmacho.obj: output\outmacho.c include\compiler.h include\error.h \
 include\hashtbl.h include\ilog2.h include\labels.h include\nasm.h \
 include\nasmlib.h include\nctype.h include\raa.h include\rbtree.h \
 include\saa.h include\ver.h output\dwarf.h output\macho.h output\outform.h \
 output\outlib.h
output\outobj.obj: output\outobj.c asm\eval.h asm\stdscan.h \
 include\compiler.h include\error.h include\nasm.h include\nasmlib.h \
 include\nctype.h include\ver.h output\outform.h output\outlib.h
stdlib\snprintf.obj: stdlib\snprintf.c include\compiler.h include\nasmlib.h
stdlib\strlcpy.obj: stdlib\strlcpy.c include\compiler.h
stdlib\strnlen.obj: stdlib\strnlen.c include\compiler.h
stdlib\strrchrnul.obj: stdlib\strrchrnul.c include\compiler.h
stdlib\vsnprintf.obj: stdlib\vsnprintf.c include\compiler.h include\error.h \
 include\nasmlib.h
x86\disp8.obj: x86\disp8.c include\disp8.h
x86\iflag.obj: x86\iflag.c include\iflag.h
x86\insnsa.obj: x86\insnsa.c include\insns.h include\nasm.h
x86\insnsb.obj: x86\insnsb.c include\insns.h include\nasm.h
x86\insnsd.obj: x86\insnsd.c include\insns.h include\nasm.h
x86\insnsn.obj: x86\insnsn.c include\tables.h
x86\regdis.obj: x86\regdis.c x86\regdis.h
x86\regflags.obj: x86\regflags.c include\nasm.h include\tables.h
x86\regs.obj: x86\regs.c include\tables.h
x86\regvals.obj: x86\regvals.c include\tables.h
