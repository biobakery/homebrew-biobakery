
class Picrust < Formula
  desc "PICRUSt: Phylogenetic Investigation of Communities by Reconstruction of Unobserved States"
  homepage "http://picrust.github.io/"
  url "https://github.com/picrust/picrust/releases/download/1.1.1/picrust-1.1.1.tar.gz"
  version "1.1.1"
  sha256 "d2e1c03fabc2ab4b9a3ffe1abd23c39f9fed43a057191373c105d3a859b19956"

  # add the option to build without python
  option "without-python", "Build without python2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard

  # add the biom h5py requirement
  depends_on "hdf5" => :recommended

  # add the option to install without biom dependencies
  option "without-biom", "Don't install the biom dependencies (ie biom, h5py, pqyi)"

  resource "biom-format" do
    url "https://pypi.python.org/packages/46/a6/fccc2f5db587d7d896b52054aa5a9f0f7fd8fb6ad23ab9a02934d4cb1739/biom-format-2.1.6.tar.gz"
    sha256 "8eefc275a85cc937f6d6f408d91b7b45eae854cd5d1cbda411a3af51f5b49b0d"
  end

  resource "h5py" do
    url "https://pypi.python.org/packages/11/6b/32cee6f59e7a03ab7c60bb250caff63e2d20c33ebca47cf8c28f6a2d085c/h5py-2.7.0.tar.gz"
    sha256 "79254312df2e6154c4928f5e3b22f7a2847b6e5ffb05ddc33e37b16e76d36310"
  end

  resource "cogent" do
    url "https://pypi.python.org/packages/source/c/cogent/cogent-1.5.3.tgz"
    sha256 "1215ac219070b7b2207b0b47b4388510f3e30ccd88160aa9f02f25d24bcbcd95"
  end

  resource "pyqi" do
    url "https://pypi.python.org/packages/source/p/pyqi/pyqi-0.3.2.tar.gz"
    sha256 "8f1711835779704e085e62194833fed9ac2985e398b4ceac6faf6c7f40f5d15f"
  end

  resource "click" do
    url "https://pypi.python.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "future" do
    url "https://pypi.python.org/packages/00/2b/8d082ddfed935f3608cc61140df6dcbf0edea1bc3ab52fb6c29ae3e81e85/future-0.16.0.tar.gz"
    sha256 "e39ced1ab767b5936646cedba8bcce582398233d6a627067d4c6a454c90cfedb"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  # install a numpy prior to v1.9 to prevent matrix rank deprecated warnings
  resource "numpy" do
    url "https://pypi.python.org/packages/source/n/numpy/numpy-1.7.1.tar.gz"
    sha256 "5525019a3085c3d860e6cfe4c0a30fb65d567626aafc50cf1252a641a418084a"
  end

  resource "scipy" do
    url "https://pypi.python.org/packages/34/ac/f793c8f18b6f188788b37aae02d94689ac8df317f09a681a3a61ecc466ab/scipy-0.13.0.tar.gz"
    sha256 "e7fe93ffc4b55d8357238406b1b9e47a4f932474238e2bfdb552423bcd45dc5e"
  end

  resource "pandas" do
    url "https://pypi.python.org/packages/source/p/pandas/pandas-0.13.1.tar.gz"
    sha256 "6813746caa796550969ed98069f16627f070f6d8d60686cfb3fa0e66c2e0312b"
  end

  resource "dateutil" do
    url "https://pypi.python.org/packages/3e/f5/aad82824b369332a676a90a8c0d1e608b17e740bbb6aeeebca726f17b902/python-dateutil-2.5.3.tar.gz"
    sha256 "1408fdb07c6a1fa9997567ce3fcee6a337b39a503d80699e0f213de4aa4b32ed"
  end

  resource "16S_13_5" do
    url "ftp://ftp.microbio.me/pub/picrust-references/picrust-1.0.0/16S_13_5_precalculated.tab.gz"
    sha256 "ae9c25bda0bdc52db054f311e765daa1bcfc33b35261cc57b379938ef9feff3f"
  end

  resource "ko_13_5" do
    url "ftp://ftp.microbio.me/pub/picrust-references/picrust-1.0.0/ko_13_5_precalculated.tab.gz"
    sha256 "26371c9eaf8decdfea0a6b2ae887a13789b762dc15da60629f5efda564750ce6"
  end

  def install
    # set PYTHONPATH to location where package will be installed (relative to homebrew location)
    ENV.prepend_create_path 'PYTHONPATH', libexec/"lib/python2.7/site-packages"
    ENV.prepend_create_path 'PYTHONPATH', libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path 'PYTHONPATH', libexec/"vendor/lib64/python2.7/site-packages"

    # install dependencies
    # update LDFLAGS for numpy install
    ENV.append "LDFLAGS", "-shared" if OS.linux?
    for python_package in ["numpy", "cogent"]
        resource(python_package).stage do
            system "python2", *Language::Python.setup_install_args(libexec/"vendor")
        end
    end

    if build.with? "biom"
    for python_package in ["scipy", "pandas", "future", "six", "click", "pyqi", "h5py", "biom-format", "dateutil"]
            resource(python_package).stage do
                system "python2", *Language::Python.setup_install_args(libexec/"vendor")
            end
        end
    end
    # run python setup.py install using recommended homebrew helper method with destination prefix of libexec
    system "python2", *Language::Python.setup_install_args(libexec)
    # copy all of the installed scripts to the homebrew bin
    bin.install Dir[libexec/"bin/*"]
    # write stubs to bin that set PYTHONPATH and call executables, move executables back to original location
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
   
    # create the data folder
    system "mkdir", libexec/"lib/python2.7/site-packages/picrust/data"
 
    # stage downloaded resource in temp directory and install in picrust data folder
    libexec.install resource("16S_13_5")
    system "mv", libexec/"16S_13_5_precalculated.tab", libexec/"lib/python2.7/site-packages/picrust/data/16S_13_5_precalculated.tab"
    system "gzip", libexec/"lib/python2.7/site-packages/picrust/data/16S_13_5_precalculated.tab"
    libexec.install resource("ko_13_5")
    system "mv", libexec/"ko_13_5_precalculated.tab", libexec/"lib/python2.7/site-packages/picrust/data/ko_13_5_precalculated.tab"
    system "gzip", libexec/"lib/python2.7/site-packages/picrust/data/ko_13_5_precalculated.tab"
  end

  test do
    system "#{bin}/predict_metagenomes.py", "--help"
  end
end
