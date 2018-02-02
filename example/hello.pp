# example package

%set
  name=hello
  version=1.0.0.0
  summary="Hello world"
  description="Engenders a global greeting"

%set [bsd]
  pp_bsd_message="Greetings!"
  pp_bsd_category="security"
  pp_bsd_origin="security/${pp_bsd_name:-$name}"
  pp_bsd_prefix="/tmp/${pp_bsd_name:-$name}"

%depend
  grep

%pre
  echo This is the PRE-INSTALL script

%post
  echo This is the POST-INSTALL script
  %(pp_functions pp_mkuser)


%preun
  echo This is the PRE-UNINSTALL script
%postun
  echo This is the POST-UNINSTALL script

%service hellod
  cmd=${sbindir}/hellod

%files
  ${bindir}/
  ${sbindir}/
  ${sysconfdir}/
  ${libdir}/
  ${bindir}/hello
  ${bindir}/goodbye
  ${sbindir}/hellod
  ${sysconfdir}/hello.conf  644 volatile
  ${libdir}/hello/
  ${libdir}/slink

%files dev
  ${bindir}/
  ${bindir}/hello-config

%fixup
  echo This is the FIXUP script
