# homebrew-biobakery #

**The bioBakery Homebrew packages are no longer supported. They have been replaced with Conda packages and Docker images.** Please see the [bioBakery documentation](https://bitbucket.org/biobakery/biobakery/wiki/biobakery_wiki) for information about how to install the tools with these two new methods.

Biobakery formulae for the Homebrew package manager.

To get started, install [HomeBrew](http://brew.sh/) for MacOS or [LinuxBrew](http://linuxbrew.sh/) for Linux platforms. 

## Install the full biobakery tool suite plus biobakery demos ##

1. Install dependencies [Java Runtime Environment](http://www.oracle.com/technetwork/java/javase/downloads/jre7-downloads-1880261.html), [USEARCH](http://www.drive5.com/usearch/), and freetype/lapack/blas (required by matplotlib; available through brew depending on your operating system (ie "brew install freetype"))
2. Install the tool suite
    * `` $ brew tap biobakery/biobakery ``
    * `` $ brew install biobakery_tool_suite ``
3. Test the install
    * `` $ biobakery_demos --tool all --mode test ``
    * Testing all tools takes about 45 minutes.

If you have any issues installing dependencies of the tool suite and you have root permissions, install the [bioBakery Docker images](https://hub.docker.com/u/biobakery/).

## Install individual biobakery tools ##

If you do not want to install the full tool suite, you can select individual tools to install. 

1. Tap the biobakery homebrew repository
    * `` $ brew tap biobakery/biobakery ``
2. Install the individual tools needed  
    1. HUMAnN2
        * `` $ brew install humann2 ``
        * Add the option ``--with-python3`` to install with python3 (by default it is installed with python2).
        * Demo databases are included with the install. To install the full databases, see the [humann2 documentation](http://huttenhower.sph.harvard.edu/humann2).
    2. KneadData
        * Install [Java Runtime Environment](http://www.oracle.com/technetwork/java/javase/downloads/jre7-downloads-1880261.html)
        * `` $ brew install kneaddata ``
        * Add the option ``--with-python3`` to install with python3 (by default it is installed with python2).
        * Demo databases are included with the install. To install the full databases, see the [kneaddata documentation](http://huttenhower.sph.harvard.edu/kneaddata).
    3. Picrust
        * `` $ brew install picrust ``
    4. MaAsLin
        * `` $ brew install maaslin ``
    5. MetaPhlAn2
        * `` $ brew install metaphlan2 ``
        * Add the option ``--with-python3`` to install with python3 (by default it is installed with python2).
    6. ShortBRED
        * Install [USEARCH](http://www.drive5.com/usearch/)
        * `` $ brew install shortbred ``
    7. SparseDOSSA
        * `` $ brew install sparsedossa ``
    8. PPANINI
        * Install [USEARCH](http://www.drive5.com/usearch/)
        * `` $ brew install ppanini ``
    9. LEfSe
        * `` $ brew install lefse ``
    10. GraPhlAn
        * `` $ brew install graphlan ``
    11. MicroPITA
        * `` $ brew install micropita ``
    12. BreadCrumbs
        * `` $ brew install breadcrumbs ``
    13. StrainPhlAn
        * `` $ brew install strainphlan ``
    14. HAllA
        * `` $ brew install halla ``
        * Add the option ``--with-python3`` to install with python3 (by default it is installed with python2).
    15. Hclust2
        * `` $ brew install hclust2 ``
    16. PanPhlAn
        * `` $ brew install panphlan ``
        * Add the option ``--with-python3`` to install with python3 (by default it is installed with python2).
    17. bioBakery workflows
        * `` $ brew install workflows ``
        * Install [Pandoc](http://pandoc.org/) (only required for the visualization workflows)
        * Install LaTeX package with pdflatex, like TeXLive (only required for the visualization workflows)
        * Add the following to your PYTHONPATH to use this tool as a python library (export HOMBREW_PREFIX=$(brew --prefix))
            * $HOMEBREW_PREFIX/lib/python2.7/site-packages
            * $HOMEBREW_PREFIX/lib/python2.7/dist-packages
            * $HOMEBREW_PREFIX/lib64/python2.7/site-packages
        * Add the following to your R_LIBS to use this tool as a python library (if you require auto-doc features)
            * $HOMEBREW_PREFIX/R/library
3. Test the individual installs
    1. Install biobakery_demos
        * `` $ brew install biobakery_demos ``
    2. Test an individual tool install
        * `` $ biobakery_demos --tool humann2 --mode test ``
    3. You can also view the commands for each demo run
        * `` $ biobakery_demos --tool humann2 --mode view ``
    4. And you can run a demo and view the output files created
        * `` $ biobakery_demos --tool humann2 --mode run --output humann2_demo_output ``

## FAQs ##

1. How do I get the latest formulas?
  To get the latest formulas run, ``$ brew update``.

2. I have installed a lot of tools and my brew install folder takes up a lot of space. How can I free up space?
  Downloads for formulas are automatically installed in the brew cache. This way you only have to download something once but
  it also can use up disk space. To remove the cache run, ``$ rm -rf $(brew --cache)``. 

3. How do I list the names of the brew tools and versions installed?
  Run the following command to list all of the tools and their versions, ``$ brew list --versions``.

4. What should I do if I see an error during install that freetype is not installed but I have already installed freetype?
  Matplotlib is required by some of the tools and it depends on freetype. Matplotlib expects a specific freetype header to be installed
  in a specific folder and brew (and other package managers) don't always install the headers in this folder. If you are seeing
  this issue run the command ``$ locate freetype | grep ft2build.h`` to find where the header file is located. Then run the
  command ``$ ln -s /usr/include/freetype2/ft2build.h /usr/include/`` (replacing the initial location with the one from
  the first command) to link this file to the location where matplotlib expects it. This should resolve the issue.

5. What should I do if I see errors about python2?
  The tools by default are installed with the python2 executable. For most environments on Linux and MacOS, you should have a
  python2 executable. If you run ``$ which python2`` and python2 is not found you are likely in a python3 conda environment.
  If this is the case, then search for python3. If python3 is found add the option ``--with-python3`` to install the tool
  with python3. The python3 install is available for all tools that are python2/3 compatible. 

6. What should I do if I am seeing errors installing dependencies?
  The tools install some dependencies (like numpy/scipy/matplotlib) from source to get the exact version the tool
  has been developed and tested with. If you have issues, you can try installing the formula without the dependency. For example,
  tools with numpy as a dependency have the option ``--without-numpy`` which will allow you to bypass the numpy
  install step. Options exist to bypass installing may specific dependencies. For a complete list of options, run
  ``$ brew info FORMLUA``, replacing FORMULA with that for which you would like to know the available options.
  Alternatively, you can choose to not install all of the python packages by using the flag
  ``--without-python-packages``. If you do not install these dependencies, please install them with a different
  package manager like pip or apt-get depending on your platform. A flag also exists to bypass installing
  the R packages for those formulas that have R dependencies (``--bypass-r-packages``).

