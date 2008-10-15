# example package

%set
  name=hello
  version=1.0.0.0
  summary="Hello world"
  description="Engenders a global greeting"

%depend

%post
  echo This is the POST-INSTALL script
  %(pp_functions pp_mkuser)

%preun
  echo This is the UNINSTALL script

%service hellod
  cmd=${sbindir}/hellod

%files
  ${bindir}/hello
  ${bindir}/goodbye
  ${sbindir}/hellod
  ${sysconfdir}/hello.conf  644 volatile
  ${libdir}/hello/

%files dev
  ${bindir}/hello-config
