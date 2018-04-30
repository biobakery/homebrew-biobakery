class Maaslin < Formula
  desc "MaAsLin: Multivariate Association with Linear Models"
  homepage "http://huttenhower.sph.harvard.edu/maaslin"
  url "https://bitbucket.org/biobakery/maaslin/downloads/Maaslin_0.0.5.tar.gz"
  version "0.0.5"
  sha256 "7019bda725adf7623b1437239646ffeb3cba2386c701ecb277a41a18a6bd58a3"

  # add the option to build with r   
  option "with-r", "Build with R support"
  depends_on "r" => [:optional, "without-x"]

  # add the option to not install the python dependencies
  option "without-dependencies", "Don't install the python dependencies (blist)"

  resource "blist" do
    url "https://pypi.python.org/packages/source/b/blist/blist-1.3.6.tar.gz"
    sha256 "3a12c450b001bdf895b30ae818d4d6d3f1552096b8c995f0fe0c74bef04d1fc3"
  end

  resource "gam" do
    url "https://cran.r-project.org/src/contrib/Archive/gam/gam_1.14.tar.gz"
    sha256 "6653a98302058d4e1c84d28b3b3243113077c9a09fc8d4f8f1541186aa5561fc"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib64/python2.7/site-packages"
    # install dependencies if set
    if build.with? "dependencies"
      for python_package in ["blist"]
        resource(python_package).stage do
          system "python2", *Language::Python.setup_install_args(libexec/"vendor")
        end
      end
    end

    # set R_LIBS to location where package will be installed (relative to homebrew location)
    ENV.prepend_create_path "R_LIBS", libexec

    # copy all of the installed scripts to the homebrew bin
    bin.install Dir["R/*"]  
    bin.install Dir["exec/*"]  
    
    # write stubs to bin that set R_LIBS and call executables, move executables back to original location
    bin.env_script_all_files(lib/"bin", { :PYTHONPATH => ENV["PYTHONPATH"] , :R_LIBS => ENV["R_LIBS"] })

    # install gam required dependencies
    for r_package in ["foreach"]
        system "R", "-q", "-e", "install.packages('" + r_package + "', lib='" + libexec + "', repos='http://cran.r-project.org')"
    end

    # install older gam package prior to bug being introduced that results in argument of length zero error
    for r_package in ["gam"]
      resource(r_package).stage do
        system "R", "CMD", "INSTALL", "."
      end
    end

    # install maaslin as an R package, also install required dependencies
    for r_package in ["agricolae","gamlss","gbm","glmnet","inlinedocs","logging","MASS","nlme","optparse","outliers","penalized","pscl","robustbase","tools"]
        system "R", "-q", "-e", "install.packages('" + r_package + "', lib='" + libexec + "', repos='http://cran.r-project.org')"
    end
  end

  test do
    system "#{bin}/Maaslin.R", "--help"
  end
end
