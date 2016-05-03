class Metaphlan2 < Formula
  desc "MetaPhlAn 2.0: Metagenomic Phylogenetic Analysis"
  homepage "https://bitbucket.org/biobakery/metaphlan2"
  url "https://bitbucket.org/biobakery/metaphlan2/get/c07beded1dc3a7eb7a1f8434c6ec7325a48d1675.tar.gz"
  version "2.3.0-c07bede"
  sha256 "1e697b2c5fc2ad8131f7e9aa035aea19da7e31089d6b761d9555052e6119b3d4"

  # add the option to build without python
  option "without-python", "Build without python2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard

  depends_on "homebrew/science/bowtie2" => [:recommended, "without-tbb"]

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
    bin.install prefix/"metaphlan2.py"
    bin.env_script_all_files(prefix, :PYTHONPATH => ENV["PYTHONPATH"])
    bin.install_symlink prefix/"db_v20"
  end

  test do
    system "#{bin}/metaphlan2.py", "--version"
  end
end
