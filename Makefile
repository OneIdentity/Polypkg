# (c) 2007 Quest Software, Inc. All rights reserved.

PP_SHELL=	/bin/sh

PP_SRCS= \
	 pp.main \
	 pp.util \
	 pp.front \
	 pp.platform \
	 pp.expand \
	 pp.model \
	 pp.back \
         pp.back.aix \
         pp.back.sd \
	 pp.back.solaris \
	 pp.back.solaris.svc \
	 pp.back.deb \
	 pp.back.deb.svc \
	 pp.back.rpm \
	 pp.back.rpm.svc \
	 pp.back.macos \
	 pp.back.null \
	 pp.quest

all: pp check
	cd example && $(MAKE)

# Generate a pp that includes the sources with the '.' operator.
# This is most handy for development because the source line numbers
# will be correct in error messages.
pp: $(PP_SRCS)
	rm -f $@
	(echo '#!$(PP_SHELL)';                \
	 echo 'pp_revision="$(shell svnversion . | tr : _)"'; \
	 echo 'd=`dirname $$0`';          \
	 for p in $(PP_SRCS); do          \
	    echo '. "$$d/'$$p'" &&';        \
	 done;                            \
	 echo 'pp_main $${1+"$$@"}'       \
	) > $@
	chmod 555 $@

# Generate an exportable pp script. Source files have their comments
# removed and are concatenated together to make the shippable pp script.
pp-stripped: $(PP_SRCS)
	(echo '#!$(PP_SHELL)';                \
	 echo "# (c) `date +%Y` Quest Software, Inc. All rights reserved"; \
	 echo 'pp_revision="$(shell svnversion . | tr : _)"'; \
	 cat pp.licence; \
	 sed -e '/^#/d' $(PP_SRCS);	\
	 echo 'pp_main $${1+"$$@"}';	\
	 ) > $@
	chmod +x $@

clean:
	rm -f pp pp-stripped tags
	cd example && $(MAKE) clean

TEST_SHELL=sh

check: pp
	@ex=0; for t in tests/t-*; do \
	    ${TEST_SHELL} -f tests/driver $$t || ex=1; \
	done; exit $$ex

# Create a tags file (used by vi). Shell functions are detected
# by being preceeded by a descriptive comment starting with '#@'
tags: $(PP_SRCS)
	for f in $(PP_SRCS); do \
	    : sed -n -e 's,^\(#@[ 	]*\$$*\([^(:/ ]*\)[^:]*:*\).*,\2	'$$f'	/^\1/,p' $$f; \
	    sed -n -e 's,^\(\([a-zA-Z_][a-zA-Z_0-9]*\)[ 	]*(\))[ 	]*{.*,\2	'$$f'	/^\1/,p' \
		-e 's,^\(\([a-zA-Z_][a-zA-Z_0-9]*\)=\).*,\2	'$$f'	/^\1/,p' $$f; \
	done |sort > $@

install: pp-stripped
	PPVER=`./pp-stripped --version | cut -d. -f 4`; \
	    case $$PPVER in \
		*M*|*_*) \
		    echo "Refusing to install unclean version $$PPVER" >&2; \
		    exit 1;; \
	    esac
	cp -f pp-stripped /data/rc/pub/rc/polypkg/pp
