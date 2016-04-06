class Breadcrumbs < Formula
  desc "Miscellaneous Huttenhower Lab scripts"
  homepage "https://bitbucket.org/biobakery/breadcrumbs"
  url "https://bitbucket.org/biobakery/breadcrumbs/get/016fa31153e6.tar.gz"
  version "016fa31153e6"
  sha256 "0fd271f87e94d205dc34324920e33e3f65e150c18431a0f4460cbfb7bceaf915"

  # add the option to build without python
  option "without-python", "Build without python2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard
 
  # add the option to build with r 
  option "with-r", "Build with R support"
  depends_on "r" => [:optional, "without-x"]

  depends_on "bowtie2" => [:recommended, "without-tbb"]

  resource "numpy" do
    url "https://pypi.python.org/packages/source/n/numpy/numpy-1.7.1.tar.gz"
    sha256 "5525019a3085c3d860e6cfe4c0a30fb65d567626aafc50cf1252a641a418084a"
  end

  resource "scipy" do
    url "https://pypi.python.org/packages/source/s/scipy/scipy-0.12.0.tar.gz"
    sha256 "b967e802dafe2db043cfbdf0043e1312f9ce9c1386863e1c801a08ddfccf9de6"
  end

  resource "matplotlib" do
    url "https://pypi.python.org/packages/source/m/matplotlib/matplotlib-1.5.1.tar.gz"
    sha256 "3ab8d968eac602145642d0db63dd8d67c85e9a5444ce0e2ecb2a8fedc7224d40"
  end

  resource "biom-format" do
    url "https://pypi.python.org/packages/source/b/biom-format/biom-format-1.3.1.tar.gz"
    sha256 "03e750728dc2625997aa62043adaf03643801ef34c1764213303e926766f4cef"
  end

  resource "pyqi" do
    url "https://pypi.python.org/packages/source/p/pyqi/pyqi-0.3.2.tar.gz"
    sha256 "8f1711835779704e085e62194833fed9ac2985e398b4ceac6faf6c7f40f5d15f"
  end

  resource "cogent" do
    url "https://github.com/pycogent/pycogent/archive/1.5.3-release.tar.gz"
    sha256 "4e19325cd1951382dc71582eb49f44c5a19eb128e3540e29dc28e080091e49cd"
  end

  resource "blist" do
    url "https://pypi.python.org/packages/source/b/blist/blist-1.3.6.tar.gz"
    sha256 "3a12c450b001bdf895b30ae818d4d6d3f1552096b8c995f0fe0c74bef04d1fc3"
  end
  
  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib64/python2.7/site-packages"
    ENV.append "LDFLAGS", "-shared" if OS.linux?
    %w[numpy scipy matplotlib biom-format pyqi blist].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    resource("cogent").stage do
      ENV["CFLAGS"] += " -I./include -I" + ENV["HOMEBREW_PREFIX"]+"/lib/python2.7/site-packages/numpy/core/include "
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    args = Language::Python.setup_install_args(libexec)
    args[1].gsub! "setup.py", "actually_setup.py"
    system "python", *args
    prefix.install Dir["*"]
    bin.install Dir["#{prefix}/breadcrumbs/scripts/*.py"]
    bin.env_script_all_files(prefix/"scripts", :PYTHONPATH => ENV["PYTHONPATH"])

    ENV.prepend_create_path "R_LIBS", libexec/"vendor/R/library"
    system "R", "-q", "-e", "install.packages('vegan', lib='" + libexec/"vendor/R/library" + "', repos='http://cran.r-project.org')"
    system "R", "-q", "-e", "install.packages('r_optparse', lib='" + libexec/"vendor/R/library" + "', repos='http://cran.r-project.org')"

    # write a new env stub script to the libexec bin folder
    # then symlink this script to the bin folder
    # at the end of the install homebrew symlinks the bin folder to $HOMEBREW/bin
    # also need to change permissions as by default this new script is not executable
    new_r_script = libexec/"bin/scriptBiplotTSV.R"
    new_r_script.write_env_script(prefix/"breadcrumbs/scripts/scriptBiplotTSV.R", :R_LIBS => ENV["R_LIBS"])
    bin.install_symlink libexec/"bin/scriptBiplotTSV.R"
    new_r_script.chmod 0755
  end

  test do
    system "#{bin}/scriptPcoa.py", "--help"
  end
end
