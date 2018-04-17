class Strainphlan < Formula
  desc "StrainPhlAn"
  homepage "https://bitbucket.org/biobakery/metaphlan2"
  url "http://huttenhower.sph.harvard.edu/metaphlan2_downloads/strainphlan-2.6.0.tar.gz"
  version "2.6.0"
  sha256 "ead411f9665a5391ec333a94d0259f46dfafd6854c82e56026fb15b24c7c4a57"

  # add the option to build without python
  option "without-python", "Build without python2 support"
  depends_on "python" => :recommended if MacOS.version <= :snow_leopard

  depends_on "biobakery/biobakery/blast" => :recommended
  depends_on "homebrew/core/bowtie2" => [:recommended, "without-tbb"]
  depends_on "brewsci/science/muscle" => :recommended

  # required by samtools
  depends_on "ncurses" unless OS.mac?

  depends_on "bzip2" => :recommended

  # add the option to not install the numpy/scipy/matplotlib dependencies
  option "without-dependencies", "Don't install the python dependencies (numpy,scipy,matplotlib)"

  # download counter to track installs
  resource "counter" do
    url "https://bitbucket.org/biobakery/metaphlan2/downloads/strainphlan_homebrew_counter.txt"
    sha256 "c31ad00345a4a80fc0cdc01ceb42b0f9db3a5148adca78c00986f9c24fd0f4c0"
   end

  resource "biom-format" do
    url "https://pypi.python.org/packages/source/b/biom-format/biom-format-1.3.1.tar.gz"
    sha256 "03e750728dc2625997aa62043adaf03643801ef34c1764213303e926766f4cef"
  end

  # install dependency of biom-format
  resource "pyqi" do
    url "https://pypi.python.org/packages/source/p/pyqi/pyqi-0.3.2.tar.gz"
    sha256 "8f1711835779704e085e62194833fed9ac2985e398b4ceac6faf6c7f40f5d15f"
  end

  resource "numpy" do
    url "https://pypi.python.org/packages/source/n/numpy/numpy-1.11.0.tar.gz"
    sha256 "a1d1268d200816bfb9727a7a27b78d8e37ecec2e4d5ebd33eb64e2789e0db43e"
  end

  resource "pandas" do
    url "https://pypi.python.org/packages/source/p/pandas/pandas-0.13.1.tar.gz"
    sha256 "6813746caa796550969ed98069f16627f070f6d8d60686cfb3fa0e66c2e0312b"
  end

  # add cython a dependency of msgpack (optional, allows for compiled extensions)
  resource "cython" do
    url "https://pypi.python.org/packages/2f/ae/0bb6ca970b949d97ca622641532d4a26395322172adaf645149ebef664eb/Cython-0.25.1.tar.gz"
    sha256 "e0941455769335ec5afb17dee36dc3833b7edc2ae20a8ed5806c58215e4b6669"
  end

  resource "msgpack" do
    url "https://pypi.python.org/packages/source/m/msgpack-python/msgpack-python-0.4.7.tar.gz"
    sha256 "5e001229a54180a02dcdd59db23c9978351af55b1290c27bc549e381f43acd6b"
  end

  resource "pysam" do
    url "https://pypi.python.org/packages/source/p/pysam/pysam-0.9.0.tar.gz"
    sha256 "90edf568835245e03eea176196cfafdfcb3af7e5fb40e48923a63f75c266c03c"
  end

  resource "biopython" do
    url "https://pypi.python.org/packages/source/b/biopython/biopython-1.65.tar.gz"
    sha256 "6d591523ba4d07a505978f6e1d7fac57e335d6d62fb5b0bcb8c40bdde5c8998e"
  end

  resource "dendropy" do
    url "https://pypi.python.org/packages/43/22/69b7713b094697f8a432abe96c44a155519ef67b3c31221de32f4c3d5fa5/DendroPy-3.12.0.tar.gz"
    sha256 "38a0f36f2f7aae43ec5599408b0d0a4c80996b749589f025940d955a70fc82d4"
  end

  resource "raxml" do
    url "https://github.com/stamatak/standard-RAxML/archive/v8.1.15.tar.gz"
    sha256 "f0388f6c5577006dc13e2dc8c35a2e5046394f61009ec5b04fb09254f8ec25b2"
  end

  resource "dateutil" do
    url "https://pypi.python.org/packages/3e/f5/aad82824b369332a676a90a8c0d1e608b17e740bbb6aeeebca726f17b902/python-dateutil-2.5.3.tar.gz"
    sha256 "1408fdb07c6a1fa9997567ce3fcee6a337b39a503d80699e0f213de4aa4b32ed"
  end

  resource "samtools.v0.1.19" do
    url "https://github.com/samtools/samtools/archive/0.1.19.tar.gz"
    sha256 "180c120a040ec660ebecc30ebae664772c0fd503e028173ab2496379bc208c17"
  end

  resource "scipy" do
    url "https://pypi.python.org/packages/source/s/scipy/scipy-0.12.0.tar.gz"
    sha256 "b967e802dafe2db043cfbdf0043e1312f9ce9c1386863e1c801a08ddfccf9de6"
  end

  resource "matplotlib" do
    url "https://pypi.python.org/packages/source/m/matplotlib/matplotlib-1.5.1.tar.gz"
    sha256 "3ab8d968eac602145642d0db63dd8d67c85e9a5444ce0e2ecb2a8fedc7224d40"
  end

  resource "pyparsing" do
    url "https://pypi.python.org/packages/94/51/3dd26b41be55ed05e72d1da87e4a732d8b92245b1f2f7fe2fa65a4910858/pyparsing-2.1.1.tar.gz"
    sha256 "9bae5cd4cbee6da0d7d8d9a1647f5253a3b89652e707647eaf1961f4932ae6c6"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/ad/30/5ab2298c902ac92fdf649cc07d1b7d491a241c5cac8be84dd84464db7d8b/pytz-2016.4.tar.gz"
    sha256 "c823de61ff40d1996fe087cec343e0503881ca641b897e0f9b86c7683a0bfee1"
  end

  resource "cycler" do
    url "https://pypi.python.org/packages/c2/4b/137dea450d6e1e3d474e1d873cd1d4f7d3beed7e0dc973b06e8e10d32488/cycler-0.10.0.tar.gz"
    sha256 "cd7b2d1018258d7247a71425e9f26463dfb444d411c39569972f4ce586b0c9d8"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    # install metaphlan2_strainer
    ENV.prepend "PYTHONPATH", prefix, ':'
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path 'PYTHONPATH', libexec/"vendor/lib64/python2.7/site-packages"
    # Add brew bin since it is no longer included in PATH
    ENV.prepend 'PATH', File.join(HOMEBREW_PREFIX,'bin'), ':'
    ENV.prepend_create_path 'PATH', libexec/"vendor/bin"

    # download counter and remove
    resource("counter").stage do
      system "rm *counter.txt"
    end
    
    prefix.install Dir["*"]
    bin.install Dir[prefix/"*.py"]
    bin.install Dir[prefix/"strainphlan_src/*.py"]
    bin.install Dir[prefix/"utils/*"]
    bin.env_script_all_files(prefix, { :PYTHONPATH => ENV["PYTHONPATH"], :PATH => ENV["PATH"]})
    bin.install_symlink prefix/"db_v20"

    # install after metaphlan2_strainer files as these will be installed in
    # bin and we do not want to env_script these files
    # install before numpy so as to not have LDFLAGS set to shared
    # install raxml and also SSE3, both are required
    resource("raxml").stage do
      system "make", "-f", "Makefile.gcc"
      rm Dir["*.o"]
      system "make", "-f", "Makefile.PTHREADS.gcc"
      rm Dir["*.o"]
      system "make", "-f", "Makefile.SSE3.PTHREADS.gcc"
      bin.install Dir["raxml*"]
    end
    
    # install specific required samtools (v0.1.19) version locally
    # installed locally to not conflict with global newer samtools version required by panphlan
    resource("samtools.v0.1.19").stage do
        system "make"
        system "make", "-C", "bcftools"
        # copy all of the executables into the vendor bin
        system "cp samtools bcftools/bcftools bcftools/vcfutils.pl #{libexec}/vendor/bin/"
        system "cp misc/maq2sam-long misc/maq2sam-short misc/md5fa misc/md5sum-lite misc/wgsim #{libexec}/vendor/bin/"
    end

    # install dependencies if set
    if build.with? "dependencies"
      # update LDFLAGS for numpy install
      ENV.append "LDFLAGS", "-shared" if OS.linux?
      %w[numpy pandas scipy pyparsing pytz pyqi biom-format cython msgpack pysam biopython dendropy dateutil cycler six matplotlib].each do |r|
        resource(r).stage do
          system "python2", *Language::Python.setup_install_args(libexec/"vendor")
        end
      end
    end

  end

  test do
    system "#{bin}/metaphlan2.py", "--version"
  end
end
