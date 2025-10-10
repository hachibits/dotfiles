(custom-set-variables
  '(grep-files-aliases
   '(("ml" . "*.ml *.mli *.mll *.mlt *.mly *.mdx") ("all" . "* .[!.]* ..?*")
     ("el" . "*.el") ("ch" . "*.[ch]") ("c" . "*.c")
     ("cc" . "*.cc *.cxx *.cpp *.C *.CC *.c++")
     ("cchh" . "*.cc *.[ch]xx *.[ch]pp *.[CHh] *.CC *.HH *.[ch]++")
     ("hh" . "*.hxx *.hpp *.[Hh] *.HH *.h++") ("h" . "*.h")
     ("l" . "[Cc]hange[Ll]og*") ("am" . "Makefile.am GNUmakefile *.mk")
     ("m" . "[Mm]akefile*") ("tex" . "*.tex") ("texi" . "*.texi")
     ("asm" . "*.[sS]")))
 '(grep-find-ignored-directories
   '("_build" "_opam" "SCCS" "RCS" "CVS" "MCVS" ".src" ".svn" ".git" ".hg" ".bzr"
     "_MTN" "_darcs" "{arch}"))
 '(helm-make-nproc 0))
 
