class Sparsedossa < Formula
  desc "SparseDOSSA: Sparse Data Observations for the Simulation of Synthetic Abundances"
  homepage "http://huttenhower.sph.harvard.edu/sparsedossa"
  url "https://bitbucket.org/biobakery/sparsedossa/get/3629f136849374f89ac861d1e1e9a5780e27e5b8.tar.gz"
  version "1.0-dev-3629f136849374f89ac861d1e1e9a5780e27e5b8"
  sha256 "3f688d3ef0c2cda9479f0e96b4499669b825b0f2a34dcd180f3c481fb252dc08"

  # add the option to build with r   
  option "with-r", "Build with R support"
  depends_on "r" => [:optional, "without-x"]

  def install
    # set R_LIBS to location where package will be installed (relative to homebrew location)
    ENV.prepend "R_LIBS", lib

    # copy all of the installed scripts to the homebrew bin
    bin.install Dir["R/*"]  
    
    # write stubs to bin that set R_LIBS and call executables, move executables back to original location
    bin.env_script_all_files(lib/"bin", :R_LIBS => ENV["R_LIBS"])

    # install maaslin as an R package, also install required dependencies
    system "Rscript", "-e", "source('https://bioconductor.org/biocLite.R');biocLite('BiocInstaller')"
    system "Rscript", "-e", "if(!require(devtools))install.packages('devtools',repos='http://cran.us.r-project.org', lib='#{lib}');library('devtools',lib.loc='#{lib}');install_deps('.',lib='#{lib}')"
  end

  test do
    system "#{bin}/synthetic_datasets_script.R", "--help"
  end
end
