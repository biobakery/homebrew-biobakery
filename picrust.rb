
class Picrust < Formula
  desc "PICRUSt: Phylogenetic Investigation of Communities by Reconstruction of Unobserved States"
  homepage "http://picrust.github.io/"
  # Download the devel version of picrust before in progress changes were made to port to biom 2.x
  # and before error from ok_function_categories in metagenome_contributions.py
  url "https://github.com/picrust/picrust/archive/bf8f29da0903e5d22ddb57797b7ad28c16a7aaf6.zip"
  version "1.0.0-dev-bf8f29d"
  sha256 "1174b4816524fca6b1ef4fca32c2b20274d6efaacc7aa0c66ddaa73fd497e9ad"

  # add the option to build without python
  option "without-python", "Build without python2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard

  resource "biom-format" do
    url "https://pypi.python.org/packages/source/b/biom-format/biom-format-1.3.1.tar.gz"
    sha256 "03e750728dc2625997aa62043adaf03643801ef34c1764213303e926766f4cef"
  end

  resource "numpy" do
    url "https://pypi.python.org/packages/source/n/numpy/numpy-1.5.1.tar.gz"
    sha256 "c36789ec381fec09f519249744ea36a77e5534b69446a59ee73b06cac29542eb"
  end

  resource "cogent" do
    url "https://pypi.python.org/packages/source/c/cogent/cogent-1.5.3.tgz"
    sha256 "1215ac219070b7b2207b0b47b4388510f3e30ccd88160aa9f02f25d24bcbcd95"
  end

  resource "pyqi" do
    url "https://pypi.python.org/packages/source/p/pyqi/pyqi-0.3.2.tar.gz"
    sha256 "8f1711835779704e085e62194833fed9ac2985e398b4ceac6faf6c7f40f5d15f"
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
    ENV.prepend_create_path 'PYTHONPATH', libexec/"lib64/python2.7/site-packages"

    # install dependencies
    # update LDFLAGS for numpy install
    ENV.append "LDFLAGS", "-shared" if OS.linux?
    for python_package in ["numpy", "biom-format", "cogent", "pyqi"]
        resource(python_package).stage do
            system "python", *Language::Python.setup_install_args(libexec)
        end
    end

    # run python setup.py install using recommended homebrew helper method with destination prefix of libexec
    system "python", *Language::Python.setup_install_args(libexec)
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
