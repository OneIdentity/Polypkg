
PP_SRCS= pp.util pp.back pp.front pp.main pp.platform pp.expand pp.model \
         pp.back.aix \
	 pp.back.solaris \
	 pp.back.solaris.svc \
	 pp.back.rpm \
	 pp.back.rpm.svc \
	 pp.back.null

build-example: pp
	cd example && $(MAKE)

pp: $(PP_SRCS)
	rm -f $@
	(echo '#!/bin/sh';                \
	 echo 'd=`dirname $$0`';          \
	 for p in $(PP_SRCS); do          \
	    echo '. "$$d/'$$p'" &&';        \
	 done;                            \
	 echo 'pp_main $${1+"$$@"}'       \
	) > $@
	chmod 555 $@

pp-stripped: $(PP_SRCS)
	(echo '#!/bin/sh';                \
	 echo '# (c) 2006 Quest Software, Inc. All rights reserved'; \
	 sed -e '/^#/d' $(PP_SRCS);	\
	 echo 'pp_main $${1+"$$@"}';	\
	 ) > $@
	chmod +x $@

clean:
	rm -f pp pp-stripped tags
	cd example && $(MAKE) clean

check: pp
	@ex=0; for t in tests/t-*; do \
	    tests/driver $$t || ex=1; \
	done; exit $$ex

tags:
	for f in $(PP_SRCS); do \
	    : sed -n -e 's,^\(#@[ 	]*\$$*\([^(:/ ]*\)[^:]*:*\).*,\2	'$$f'	/^\1/,p' $$f; \
	    sed -n -e 's,^\(\([a-zA-Z_][a-zA-Z_0-9]*\)[ 	]*(\))[ 	]*{.*,\2	'$$f'	/^\1/,p' \
		-e 's,^\(\([a-zA-Z_][a-zA-Z_0-9]*\)=\).*,\2	'$$f'	/^\1/,p' $$f; \
	done |sort > $@
