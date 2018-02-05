class Metaphlan2 < Formula
  desc "MetaPhlAn 2.0: Metagenomic Phylogenetic Analysis"
  homepage "https://bitbucket.org/biobakery/metaphlan2"
  url "http://huttenhower.sph.harvard.edu/metaphlan2_downloads/metaphlan2-2.6.0.tar.gz"
  version "2.6.0"
  sha256 "ead411f9665a5391ec333a94d0259f46dfafd6854c82e56026fb15b24c7c4a57"

  # add the python dependencies and options
  depends_on "python" => :recommended if MacOS.version <= :snow_leopard
  option "with-python3", "Build with python3 instead of python2"
  depends_on "python3" => :optional

  depends_on "homebrew/core/bowtie2" => [:recommended, "without-tbb"]

  # add the option to not install the numpy/scipy/matplotlib dependencies
  option "without-dependencies", "Don't install the dependencies (numpy,scipy,matplotlib)"

  depends_on "bzip2" => :recommended

  # download counter to track installs
  resource "counter" do
    url "https://bitbucket.org/biobakery/metaphlan2/downloads/metaphlan2_homebrew_counter.txt"
    sha256 "26971c9d2fb41b9caafeaef957a530f6d192449f498553f2b0d40ad28fd39cc5"
  end

  resource "biom-format" do
    url "https://pypi.python.org/packages/e8/74/9b7e50c29ba548cd53eb97fb9cc1f05a2cf53aa179a64f36e93282b84f79/biom-format-2.1.5.tar.gz"
    sha256 "aac0a0c8dfb06cb40e31c52dcfecf43ac7395c8032f2390e49936fce6574e374"
  end

  # download biom format dependencies (click, future, and numpy/scipy; pyqi is only required for python2 installs)
  resource "click" do
    url "https://pypi.python.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "future" do
    url "https://pypi.python.org/packages/00/2b/8d082ddfed935f3608cc61140df6dcbf0edea1bc3ab52fb6c29ae3e81e85/future-0.16.0.tar.gz"
    sha256 "e39ced1ab767b5936646cedba8bcce582398233d6a627067d4c6a454c90cfedb"
  end

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

  resource "biopython" do
    url "http://biopython.org/DIST/biopython-1.66.tar.gz"
    sha256 "5178ea3b343b1d8710f39205386093e5369ed653aa020e1b0c4b7622a59346c1"
  end

  resource "scipy" do
    url "https://pypi.python.org/packages/34/ac/f793c8f18b6f188788b37aae02d94689ac8df317f09a681a3a61ecc466ab/scipy-0.13.0.tar.gz"
    sha256 "e7fe93ffc4b55d8357238406b1b9e47a4f932474238e2bfdb552423bcd45dc5e"
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

  resource "dateutil" do
    url "https://pypi.python.org/packages/3e/f5/aad82824b369332a676a90a8c0d1e608b17e740bbb6aeeebca726f17b902/python-dateutil-2.5.3.tar.gz"
    sha256 "1408fdb07c6a1fa9997567ce3fcee6a337b39a503d80699e0f213de4aa4b32ed"
  end

  resource "cycler" do
    url "https://pypi.python.org/packages/c2/4b/137dea450d6e1e3d474e1d873cd1d4f7d3beed7e0dc973b06e8e10d32488/cycler-0.10.0.tar.gz"
    sha256 "cd7b2d1018258d7247a71425e9f26463dfb444d411c39569972f4ce586b0c9d8"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def get_python_version
    # check the python version to install with
    if build.with? "python3"
        python="python3"
    else
        python="python2"
    end

    # get the full python version selected
    python_full_version = `#{python} --version 2>&1`

    # return an error if the python version selected is not installed
    unless $? == 0
     abort("Please install #{python}")
    end

    # get the major/minor python version to determine
    # the install folder location
    python_version = python_full_version.split(" ")[1].split(".").first(2).join(".")

    return [python, python_version]
  end

  def install
    # get the python executable and version
    python, python_version = get_python_version

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{python_version}/site-packages"
    ENV.prepend_create_path 'PYTHONPATH', libexec/"lib64/python#{python_version}/site-packages"

    # download counter and remove
    resource("counter").stage do
      system "rm *counter.txt"
    end

    # install dependencies if set
    if build.with? "dependencies"
      # update LDFLAGS for numpy install
      ENV.append "LDFLAGS", "-shared" if OS.linux?
      %w[numpy pandas scipy biopython pyparsing pytz dateutil cycler six matplotlib].each do |r|
        resource(r).stage do
          system python, *Language::Python.setup_install_args(libexec)
        end
      end

      # install biom-format with different dependencies based
      # on the python version (pyqi does not support python3.4+ and is not required for biom with python3)
      if build.with? "python3"
        %w[click future biom-format].each do |r|
          resource(r).stage do
            system python, *Language::Python.setup_install_args(libexec)
          end
        end
      else
        %w[click future pyqi biom-format].each do |r|
          resource(r).stage do
            system python, *Language::Python.setup_install_args(libexec)
          end
        end
      end
    end

    prefix.install Dir["*"]

    # if using python3, modify the scripts (by default it uses python2)
    # to use the latest python3 installed since they are executed directly
    if build.with? "python3"
      system "sed -i '1 s/python/python3/' #{prefix}/metaphlan2.py"
      Dir[prefix/"utils/*.py"].each do |script|
          system "sed -i '1 s/python/python3/' #{script}"
      end
    end
    bin.install prefix/"metaphlan2.py"
    bin.install Dir[prefix/"utils/*"]
    bin.env_script_all_files(prefix, :PYTHONPATH => ENV["PYTHONPATH"])
    bin.install_symlink prefix/"db_v20"
  end

  test do
    system "#{bin}/metaphlan2.py", "--version"
  end
end
