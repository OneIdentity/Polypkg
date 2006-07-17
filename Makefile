
PP_SRCS= pp.util pp.back pp.front pp.main pp.platform pp.expand pp.model \
         pp.back.aix \
	 pp.back.solaris \
	 pp.back.rpm pp.back.rpm.svc \
	 pp.back.null

build-example: pp
	cd example && $(MAKE)

pp: $(PP_SRCS)
	rm -f $@
	(echo '#!/bin/sh';                \
	 echo 'd=`dirname $$0`';          \
	 for p in $(PP_SRCS); do          \
	    echo '. $$d/'$$p' || exit 1'; \
	 done;                            \
	 echo 'pp_main $${1+"$$@"}'       \
	) > $@
	chmod 555 $@

clean:
	rm -f pp tags
	cd example && $(MAKE) clean

test: pp
	@ex=0; for t in tests/t-*; do \
	    tests/driver $$t || ex=1; \
	done; exit $$ex

tags:
	for f in $(PP_SRCS); do \
	    : sed -n -e 's,^\(#@[ 	]*\$$*\([^(:/ ]*\)[^:]*:*\).*,\2	'$$f'	/^\1/,p' $$f; \
	    sed -n -e 's,^\(\([a-zA-Z_][a-zA-Z_0-9]*\)[ 	]*(\))[ 	]*{.*,\2	'$$f'	/^\1/,p' \
		-e 's,^\(\([a-zA-Z_][a-zA-Z_0-9]*\)=\).*,\2	'$$f'	/^\1/,p' $$f; \
	done |sort > $@
