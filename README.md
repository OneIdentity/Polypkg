One Identity open source projects are supported through One Identity GitHub issues and the One Identity Community. This includes all scripts, plugins, SDKs, modules, code snippets or other solutions. For assistance with any One Identity GitHub project, please raise a new Issue on the One Identity GitHub project page. You may also visit the One Identity Community to ask questions. Requests for assistance made through official One Identity Support will be referred back to GitHub and the One Identity Community forums where those requests can benefit all users.

# Polypkg
A cross-platform packaging tool that attempts to automate package building for Unix/Linux Systems

## Design Goals
**pp** is a shell script with the following design goals/wish list
* Easily redistributable with source packages (cf. configure, libtool)
* Portable across platforms of interest (Linux, AIX, HPUX, Solaris)
* Uses native platform package management tools (rpm, swinstall, installp, pkgadd)
* Generates init scripts for services
* Understands a lowest common denominator subset of 'components'. Components are independent but related packages, and currently include runtime documentation, developer libraries and debugging information
* Can generates the debug component automatically
* The input text is conceptually an extension of Bourne Shell (i.e. no new language to learn, yet permits fine-control, uh.. hacks)
* All symbols start with pp_ to avoid user script conflict
* Can automatically copy packages into a snapshot distribution area with a sane layout
* Parameter substitution in post-install/service script fragments

## Supported Package Types
* IBM AIX (bff)
* FreeBSD (pkg)
* Debian (deb)
* SGI IRIX (inst)
* HP Tru64 Unix (kit)
* HP-UX (depot)
* macOS (pkg)
* Redhat Package Manager (rpm)
* Oracle Solaris (pkg)

## Synopsis
```
usage: pp [options] [input.pp]
    -d --debug                  -- write copious info to stderr
       --destdir=path           -- defaults to $DESTDIR
    -? --help                   -- display this information
    -i --install                -- install after packaging
    -l --list                   -- write package filenames to stdout
       --no-clean               -- don't remove temporary files
       --no-package             -- do everything but create packages
       --only-front             -- only perform front-end actions
    -p --platform=platform      -- defaults to local platform
       --wrkdir=path            -- defaults to subdirectory of  or /tmp
    -v --verbose                -- write info to stderr
       --version                -- display version and quit
```
## Architecture
As a shell script, **pp** has a simple design:
```
             ------------PolyPkg-----------
spec file -> front-end -> model -> back-end -> package
             ------------------------------
```

### Front end
This stage parses the spec file; removes comments, and performs section handling. It either calls into the model on each line of input, or stores section bodies into files to pass to the model later.
### Model
The model stage is just an internal representation of the package: the number of components defined, names of declared services, and also provides a generic view of the file set. The result of this stage is a directory full of well-known file names containing pre-examined/processed filenames, script fragments etc.
### Back end
This is the platform-specific code which takes the collection of script fragment files, fileset lists and generates the output package file(s).

## Examples
* [sudo](https://github.com/sudo-project/sudo/blob/master/sudo.pp)
* [DNSUpdate](https://github.com/OneIdentity/dnsupdate/blob/master/dnsupdate.pp)

## See Also
Other cross-platform packaging tools with similar goals to **pp** include:
* [pkgutils](http://www.thewrittenword.com/projects/pkgutils/)
* [ESP Package Manager](https://www.msweet.org/epm/)
