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
    url "https://pypi.python.org/packages/source/n/numpy/numpy-1.11.0.tar.gz"
    sha256 "a1d1268d200816bfb9727a7a27b78d8e37ecec2e4d5ebd33eb64e2789e0db43e"
  end

  resource "pandas" do
    url "https://pypi.python.org/packages/source/p/pandas/pandas-0.13.1.tar.gz"
    sha256 "6813746caa796550969ed98069f16627f070f6d8d60686cfb3fa0e66c2e0312b"
  end

  resource "biopython" do
    url "https://pypi.python.org/packages/source/b/biopython/biopython-1.65.tar.gz"
    sha256 "6d591523ba4d07a505978f6e1d7fac57e335d6d62fb5b0bcb8c40bdde5c8998e"
  end

  resource "pyqi" do
    url "https://pypi.python.org/packages/source/p/pyqi/pyqi-0.3.2.tar.gz"
    sha256 "8f1711835779704e085e62194833fed9ac2985e398b4ceac6faf6c7f40f5d15f"
  end

  resource "scipy" do
    url "https://pypi.python.org/packages/source/s/scipy/scipy-0.12.0.tar.gz"
    sha256 "b967e802dafe2db043cfbdf0043e1312f9ce9c1386863e1c801a08ddfccf9de6"
  end

  resource "matplotlib" do
    url "https://pypi.python.org/packages/source/m/matplotlib/matplotlib-1.5.1.tar.gz"
    sha256 "3ab8d968eac602145642d0db63dd8d67c85e9a5444ce0e2ecb2a8fedc7224d40"
  end

  resource "hclust" do
    url "https://bitbucket.org/nsegata/hclust2/get/277c0d6a1d52.tar.gz"
    sha256 "4596de8fd0a7bb6536e9b7dfd39ca732376044c34416513cafa72918ec818038"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    ENV.prepend_create_path 'PYTHONPATH', libexec/"lib64/python2.7/site-packages"

    # update LDFLAGS for numpy install
    ENV.append "LDFLAGS", "-shared" if OS.linux?
    %w[numpy pandas scipy matplotlib biopython pyqi biom-format].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec)
      end
    end

    # install hclust
    libexec.install resource("hclust")
    bin.install libexec/"hclust2.py"

    prefix.install Dir["*"]
    bin.install prefix/"metaphlan2.py"
    bin.install Dir[prefix/"utils/*"]
    bin.env_script_all_files(prefix, :PYTHONPATH => ENV["PYTHONPATH"])
    bin.install_symlink prefix/"db_v20"
  end

  test do
    system "#{bin}/metaphlan2.py", "--version"
  end
end
