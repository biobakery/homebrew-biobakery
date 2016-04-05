class Metaphlan2 < Formula
  desc "MetaPhlAn 2.0: Metagenomic Phylogenetic Analysis"
  homepage "https://bitbucket.org/biobakery/metaphlan2"
  url "https://bitbucket.org/biobakery/metaphlan2/get/2.2.0.tgz"
  version "2.2.0"
  sha256 "dc362b36e2b7ae13efb831c0123794f4edd54b656d5d42080ee3dcf737a5e12f"
  
  depends_on "bowtie2" => [:recommended, "without-tbb"]
  depends_on :python if MacOS.version <= :snow_leopard

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
