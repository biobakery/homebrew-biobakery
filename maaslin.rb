class Maaslin < Formula
  desc "MaAsLin: Multivariate Association with Linear Models"
  homepage "http://huttenhower.sph.harvard.edu/maaslin"
  url "https://bitbucket.org/biobakery/maaslin/get/ced3ca2a3b1d.tar.gz"
  version "0.0.3-dev-ced3ca2"
  sha256 "2208fd86d9e6b7e347c63890d9b585fe611bbf8ffc3739fb63af6e652454d06d"

  # add the option to build with r   
  option "with-r", "Build with R support"
  depends_on "r" => [:optional, "without-x"]

  resource "blist" do
    url "https://pypi.python.org/packages/source/b/blist/blist-1.3.6.tar.gz"
    sha256 "3a12c450b001bdf895b30ae818d4d6d3f1552096b8c995f0fe0c74bef04d1fc3"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib64/python2.7/site-packages"
    for python_package in ["blist"]
      resource(python_package).stage do
        system "python2", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # set R_LIBS to location where package will be installed (relative to homebrew location)
    ENV.prepend_create_path "R_LIBS", libexec

    # copy all of the installed scripts to the homebrew bin
    bin.install Dir["R/*"]  
    bin.install Dir["exec/*"]  
    
    # write stubs to bin that set R_LIBS and call executables, move executables back to original location
    bin.env_script_all_files(lib/"bin", { :PYTHONPATH => ENV["PYTHONPATH"] , :R_LIBS => ENV["R_LIBS"] })

    # install maaslin as an R package, also install required dependencies
    for r_package in ["agricolae","gam","gamlss","gbm","glmnet","inlinedocs","logging","MASS","nlme","optparse","outliers","penalized","pscl","robustbase","tools"]
        system "R", "-q", "-e", "install.packages('" + r_package + "', lib='" + libexec + "', repos='http://cran.r-project.org')"
    end
  end

  test do
    system "#{bin}/Maaslin.R", "--help"
  end
end
