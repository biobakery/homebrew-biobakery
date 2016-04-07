class Metaphlan2 < Formula
  desc "MetaPhlAn 2.0: Metagenomic Phylogenetic Analysis"
  homepage "https://bitbucket.org/biobakery/metaphlan2"
  url "https://bitbucket.org/biobakery/metaphlan2/get/2.3.0.tar.gz"
  version "2.3.0"
  sha256 "af35db3ec36f409994699a011c0cc9ab1f7656646563dbb8e652b734be4ba030"

  # add the option to build without python
  option "without-python", "Build without python2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard

  depends_on "bowtie2" => [:recommended, "without-tbb"]

  resource "biom-format" do
    url "https://pypi.python.org/packages/source/b/biom-format/biom-format-1.3.1.tar.gz"
    sha256 "03e750728dc2625997aa62043adaf03643801ef34c1764213303e926766f4cef"
  end

  resource "numpy" do
    url "https://pypi.python.org/packages/source/n/numpy/numpy-1.5.1.tar.gz"
    sha256 "c36789ec381fec09f519249744ea36a77e5534b69446a59ee73b06cac29542eb"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    ENV.prepend_create_path 'PYTHONPATH', libexec/"lib64/python2.7/site-packages"

    # update LDFLAGS for numpy install
    ENV.append "LDFLAGS", "-shared" if OS.linux?
    %w[numpy biom-format].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec)
      end
    end

    prefix.install Dir["*"]
    new_metaphlan = libexec/"bin/metaphlan2.py"
    new_metaphlan.write_env_script(prefix/"metaphlan2.py", :PYTHONPATH => ENV["PYTHONPATH"])
    bin.install_symlink libexec/"bin/metaphlan2.py"
    new_metaphlan.chmod 0755
  end

  test do
    system "#{bin}/metaphlan2.py", "--version"
  end
end
