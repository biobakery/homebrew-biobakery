class Maaslin < Formula
  desc "MaAsLin: Multivariate Association with Linear Models"
  homepage "http://huttenhower.sph.harvard.edu/maaslin"
  url "https://bitbucket.org/biobakery/maaslin/get/f1d98b996028.tar.gz"
  version "0.0.3-dev-f1d98b996028"
  sha256 "b91486103044718275f075714974644f17f2de1528d71c89b4e92c01520b4bbf"

  # add the option to build with r   
  option "with-r", "Build with R support"
  depends_on "r" => [:optional, "without-x"]

  def install
    # set R_LIBS to location where package will be installed (relative to homebrew location)
    ENV.prepend "R_LIBS", lib

    # copy all of the installed scripts to the homebrew bin
    bin.install Dir["R/*"]  
    bin.install Dir["exec/*"]  
    
    # write stubs to bin that set R_LIBS and call executables, move executables back to original location
    bin.env_script_all_files(lib/"bin", :R_LIBS => ENV["R_LIBS"])

    # install maaslin as an R package, also install required dependencies
    system "Rscript", "-e", "source('https://bioconductor.org/biocLite.R');biocLite('BiocInstaller')"
    system "Rscript", "-e", "if(!require(devtools))install.packages('devtools',repos='http://cran.us.r-project.org', lib='#{lib}');library('devtools',lib.loc='#{lib}');install_deps('.',lib='#{lib}')"
  end

  test do
    system "#{bin}/Maaslin.R", "--help"
  end
end
