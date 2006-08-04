
srcdir= 	.

prefix= 	/usr
bindir= 	$(prefix)/bin
sbindir=	$(prefix)/sbin
sysconfdir=	/etc

DESTDIR=	/tmp/destroot

PP=		../pp
PPFLAGS=	--verbose --debug --no-clean --destdir=$(DESTDIR) \
		--install-script=inst.sh
#PPFLAGS+=	--platform=aix

package: $(PP) install hello.pp
	$(PP) $(PPFLAGS) $(srcdir)/hello.pp 2>&1

installpkg:
	SUDO= $(PP) $(PPFLAGS) $(srcdir)/hello.pp
	./inst.sh list-components
	./inst.sh list-services

install: hello hello.conf
	mkdir -p $(DESTDIR)$(sysconfdir)
	cp hello.conf $(DESTDIR)$(sysconfdir)/hello.conf
	mkdir -p $(DESTDIR)$(bindir)
	cp hello.sh $(DESTDIR)$(bindir)/hello
	chmod 755 $(DESTDIR)$(bindir)/hello
	mkdir -p $(DESTDIR)$(sbindir)
	cp hellod.sh $(DESTDIR)$(sbindir)/hellod
	chmod 755 $(DESTDIR)$(sbindir)/hellod
	cp hello-config.sh $(DESTDIR)$(bindir)/hello-config
	chmod 755 $(DESTDIR)$(bindir)/hello-config
	rm -f $(DESTDIR)$(bindir)/goodbye
	ln -s hello $(DESTDIR)$(bindir)/goodbye

clean:
	rm -rf $(DESTDIR) inst.sh

inst-clean:
	rm -f $(DESTDIR)$(sysconfdir)/hello.conf \
	      $(DESTDIR)$(bindir)/hello \
	      $(DESTDIR)$(bindir)/goodbye \
	      $(DESTDIR)$(bindir)/hello-config \
	      $(DESTDIR)$(sbindir)/hellod
	-rmdir $(DESTDIR)$(sbindir)
	-rmdir $(DESTDIR)$(bindir)
	-rmdir $(DESTDIR)$(sysconfdir)
	rmdir $(DESTDIR)
