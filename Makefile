# Copyright 2019 One Identity LLC. ALL RIGHTS RESERVED.

PP_SHELL=	/bin/sh
## Set this value to a path(s) where PolyPackage is installed or can be installed
PP_INSTALLDIRS := ${PP_INSTALLDIRS}

PP_SRCS= \
	 pp.main \
	 pp.util \
	 pp.front \
	 pp.platform \
	 pp.expand \
	 pp.model \
	 pp.back \
	 pp.back.aix \
	 pp.back.aix.func \
	 pp.back.sd \
	 pp.back.sd.func \
	 pp.back.solaris \
	 pp.back.solaris.func \
	 pp.back.solaris.svc \
	 pp.back.deb \
	 pp.back.deb.svc \
	 pp.back.deb.func \
	 pp.back.kit \
	 pp.back.kit.svc \
	 pp.back.kit.kits \
	 pp.back.rpm \
	 pp.back.rpm.svc \
	 pp.back.rpm.func \
	 pp.back.macos \
	 pp.back.macos.func \
	 pp.back.inst \
	 pp.back.null \
	 pp.back.bsd \
	 pp.back.bsd.svc \
	 pp.back.bsd.func \
	 pp.back.systemd.svc \
	 pp.quest

all: pp pp-stripped check
	cd example && $(MAKE)
	@echo "Polypkg versions:"; \
	for d in $(PP_INSTALLDIRS); do \
	    if test -x $$d/pp; then \
	        echo " installed: `$$d/pp --version | cut -d' ' -f2` at $$d/pp"; \
	    fi; \
	done
	@echo " local:     "`./$< --version | cut -d' ' -f2`;

# Generate a pp that includes the sources with the '.' operator.
# This is most handy for development because the source line numbers
# will be correct in error messages.
pp: $(PP_SRCS)
	rm -f $@
	(echo '#!$(PP_SHELL)';                \
	 echo 'pp_revision="$(shell date +%Y%m%d)"'; \
	 echo 'd=`dirname $$0`';          \
	 for p in $(PP_SRCS); do          \
	    echo '. "$$d/'$$p'" &&';        \
	 done;                            \
	 echo 'pp_main "$$@"'       \
	) > $@
	chmod 555 $@

# Generate an exportable pp script. Source files have their comments
# removed and are concatenated together to make the shippable pp script.
pp-stripped: $(PP_SRCS)
	(echo '#!$(PP_SHELL)';                \
	 echo "# Copyright `date +%Y` One Identity LLC. ALL RIGHTS RESERVED"; \
	 echo 'pp_revision="$(shell date +%Y%m%d)"'; \
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
# by being preceded by a descriptive comment starting with '#@'
tags: $(PP_SRCS)
	for f in $(PP_SRCS); do \
	    sed -n -e 's,^\(\([a-zA-Z_][a-zA-Z_0-9]*\)[ 	]*(\))[ 	]*{.*,\2	'$$f'	/^\1/,p' \
		-e 's,^\(\([a-zA-Z_][a-zA-Z_0-9]*\)=\).*,\2	'$$f'	/^\1/,p' $$f; \
	done |sort > $@

install: pp-stripped
	@PPVER=`./pp-stripped --version | cut -d. -f 4`; \
	    case $$PPVER in \
		*M*|*_*) \
		    echo "Refusing to install unclean version $$PPVER" >&2; \
		    exit 1;; \
	    esac
	@for d in $(PP_INSTALLDIRS); do \
	    if test -d "$$d"; then\
	        cp -f pp-stripped $$d/pp; \
	    fi; \
	done
