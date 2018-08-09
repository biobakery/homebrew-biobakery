class Workflows < Formula
  desc "bioBakery workflows: A collection of meta'omic workflows"
  homepage "https://bitbucket.org/biobakery/biobakery_workflows"
  url "https://pypi.python.org/packages/70/7c/64769accee73cfba802fd536ca6b19990bfd444dc429038a0b0e970d4707/biobakery_workflows-0.3.1.tar.gz"
  version "0.3.1"
  sha256 "8ffadeb2c57595a33a01a3f1d341191eff0dcc1acd33280496fe220ceb02ebe9"

  # add the option to build without python
  option "without-python", "Build without python2 support"
  depends_on "python" => :recommended if MacOS.version <= :snow_leopard
 
  # install 16s workflow dependencies
  depends_on "brewsci/bio/clustal-omega" => :recommended
  depends_on "brewsci/science/ea-utils" => :recommended

  # install shotgun workflow dependencies
  # install metaphlan2_strainer (strainphlan) first which will install bowtie2
  # initial bowtie2 install will be used by humann2/kneaddata (instead of own installs)
  depends_on "biobakery/biobakery/strainphlan" => :recommended
  # install humann2 without metaphlan2 because metaphlan2_strainer (strainphlan) was installed
  depends_on "biobakery/biobakery/humann2" => [:recommended, "without-metaphlan2"]
  depends_on "biobakery/biobakery/kneaddata" => :recommended
  # install picrust which will also install biom requirement
  depends_on "biobakery/biobakery/picrust" => :recommended

  # install visualization workflow dependencies
  depends_on "biobakery/biobakery/hclust2" => :recommended

  # add the option to not install the numpy/scipy/matplotlib dependencies
  option "without-python-packages", "Don't install the required python packages (numpy/scipy/matplotlib)"
  option "without-numpy", "Don't install numpy"
  option "without-scipy", "Don't install scipy"
  option "without-matplotlib", "Don't install matplotlib"
  option "without-r-packages", "Don't install the required R packages"

  resource "numpy" do
    url "https://pypi.python.org/packages/source/n/numpy/numpy-1.7.1.tar.gz"
    sha256 "5525019a3085c3d860e6cfe4c0a30fb65d567626aafc50cf1252a641a418084a"
  end

  resource "scipy" do
    url "https://pypi.python.org/packages/source/s/scipy/scipy-0.12.0.tar.gz"
    sha256 "b967e802dafe2db043cfbdf0043e1312f9ce9c1386863e1c801a08ddfccf9de6"
  end

  # download matplotlib and dependencies
  resource "matplotlib" do
    url "https://pypi.python.org/packages/f5/f0/9da3ef24ea7eb0ccd12430a261b66eca36b924aeef06e17147f9f9d7d310/matplotlib-2.0.2.tar.gz"
    sha256 "0ffbc44faa34a8b1704bc108c451ecf87988f900ef7ce757b8e2e84383121ff1"
  end

  resource "pyparsing" do
    url "https://pypi.python.org/packages/94/51/3dd26b41be55ed05e72d1da87e4a732d8b92245b1f2f7fe2fa65a4910858/pyparsing-2.1.1.tar.gz"
    sha256 "9bae5cd4cbee6da0d7d8d9a1647f5253a3b89652e707647eaf1961f4932ae6c6"
  end

  resource "cycler" do
    url "https://pypi.python.org/packages/c2/4b/137dea450d6e1e3d474e1d873cd1d4f7d3beed7e0dc973b06e8e10d32488/cycler-0.10.0.tar.gz"
    sha256 "cd7b2d1018258d7247a71425e9f26463dfb444d411c39569972f4ce586b0c9d8"
  end

  resource "dateutil" do
    url "https://pypi.python.org/packages/3e/f5/aad82824b369332a676a90a8c0d1e608b17e740bbb6aeeebca726f17b902/python-dateutil-2.5.3.tar.gz"
    sha256 "1408fdb07c6a1fa9997567ce3fcee6a337b39a503d80699e0f213de4aa4b32ed"
  end

  # download remaining core dependencies
  resource "anadama2" do
    url "https://pypi.python.org/packages/e8/54/f9c4833fed2fd033b9b15e78b845cd9d30fc49188c6128d71431b5e2f542/anadama2-0.3.1.tar.gz"
    sha256 "758549ade3bba72f2a2b4ca92ab395b8cb715cdf79c52cab178c472938dfd20e"
  end

  resource "networkx" do
    url "https://pypi.python.org/packages/c2/93/dbb41b03cf7c878a7409c8e92226531f840a423c9309ea534873a83c9192/networkx-1.11.tar.gz"
    sha256 "0d0e70e10dfb47601cbb3425a00e03e2a2e97477be6f80638fef91d54dd1e4b8"
  end

  resource "leveldb" do
    url "https://pypi.python.org/packages/24/b5/eb76325c438d159c1f0b34ed1f864566c48f145480375561c296c95dbc4f/leveldb-0.193.tar.gz"
    sha256 "db71c26b53a4c9b70721069646bdd3dddc65459be32a80e2dfea2ebed0c5c641"
  end

  resource "cloudpickle" do
    url "https://pypi.python.org/packages/4e/39/40a2862086fdd55eb1881a499a834bfae98ce70f272ed19385f4c74ebe7c/cloudpickle-0.2.1.tar.gz"
    sha256 "eea4b655e6aed3dba39b104ad1872226e3f9e23d8d202fc003f3e65f2d125c3b"
  end

  resource "pweave" do
    url "https://pypi.python.org/packages/f6/2f/e9735b04747ae5ef29d64e0b215fb0e11f1c89826097ac17342efebbbb84/Pweave-0.25.tar.gz"
    sha256 "1c0f6921196646243eb7ff9eee742305909be2bc7a5eeeb06a7d1f66cc9758c7"
  end

  resource "markdown" do
    url "https://pypi.python.org/packages/1d/25/3f6d2cb31ec42ca5bd3bfbea99b63892b735d76e26f20dd2dcc34ffe4f0d/Markdown-2.6.8.tar.gz"
    sha256 "0ac8a81e658167da95d063a9279c9c1b2699f37c7c4153256a458b3a43860e33"
  end

  resource "subprocess32" do
    url "https://pypi.python.org/packages/b8/2f/49e53b0d0e94611a2dc624a1ad24d41b6d94d0f1b0a078443407ea2214c2/subprocess32-3.2.7.tar.gz"
    sha256 "1e450a4a4c53bf197ad6402c564b9f7a53539385918ef8f12bdf430a61036590"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "decorator" do
    url "https://pypi.python.org/packages/f3/26/876d492f2394f29401eb652ddfa53dec2bc8721861c7fe0dce1b5d0d2b6a/decorator-3.4.0.tar.gz"
    sha256 "c20b404cbb7ee5cebd506688e0114e3cd76f5ce233805a51f36e1a7988d9d783"
  end

  resource "functools32" do
    url "https://pypi.python.org/packages/c5/60/6ac26ad05857c601308d8fb9e87fa36d0ebf889423f47c3502ef034365db/functools32-3.2.3-2.tar.gz"
    sha256 "f6253dfbe0538ad2e387bd8fdfd9293c925d63553f5813c4e587745416501e6d"
  end

  def install
    # Add brew bin since it is no longer included in PATH
    ENV.prepend 'PATH', File.join(HOMEBREW_PREFIX,'bin'), ':'

    # set PYTHONPATH to location where package will be installed (relative to homebrew location)
    ENV.prepend_create_path 'PYTHONPATH', File.join(HOMEBREW_PREFIX,"lib/python2.7/site-packages")
    ENV.prepend_create_path 'PYTHONPATH', File.join(HOMEBREW_PREFIX,"lib/python2.7/dist-packages")
    ENV.prepend_create_path 'PYTHONPATH', File.join(HOMEBREW_PREFIX,"lib64/python2.7/site-packages")

    if build.with? "python-packages"
      if build.with? "numpy"
        # update LDFLAGS for numpy install
        ENV.append "LDFLAGS", "-shared" if OS.linux?
        resource("numpy").stage do
          system "python2", *Language::Python.setup_install_args(HOMEBREW_PREFIX)
        end
      end
    
      if build.with? "scipy"
        # update CFLAGS for scipy install
        ENV.append "FFLAGS", "-fPIC" if OS.linux?
        resource("scipy").stage do
          system "python2", *Language::Python.setup_install_args(HOMEBREW_PREFIX)
        end
      end

      if build.with? "matplotlib"
        %w[functools32 pyparsing cycler dateutil matplotlib].each do |r|
          resource(r).stage do
            system "python2", *Language::Python.setup_install_args(HOMEBREW_PREFIX)
          end
        end
      end

      # install core dependencies into shared python lib and bin folders
      %w[anadama2 leveldb cloudpickle pweave markdown subprocess32 six decorator networkx].each do |r|
        resource(r).stage do
          system "python2", *Language::Python.setup_install_args(HOMEBREW_PREFIX)
        end
      end
    end 

    if build.with? "r-packages"
      ENV.prepend_create_path "R_LIBS", File.join(HOMEBREW_PREFIX, "R/library")
      system "R", "-q", "-e", "install.packages('vegan', lib='" + File.join(HOMEBREW_PREFIX, "R/library") + "', repos='http://cran.r-project.org')"
    end

    # run python setup.py install, installing into local folder first
    system "python2", *Language::Python.setup_install_args(libexec)

    # copy all of the installed scripts to the homebrew bin
    bin.install Dir[libexec/"bin/*"]

    # copy the tutorial databases and libraries to the install folder
    system "cp","-r", libexec/"tutorial", File.join(HOMEBREW_PREFIX,"lib/python2.7/site-packages/")
    system "cp -r #{libexec}/lib/python2.7/site-packages/biobakery_work* " + File.join(HOMEBREW_PREFIX,"lib/python2.7/site-packages/")
    bin.env_script_all_files(libexec/"bin", { :PYTHONPATH => ENV["PYTHONPATH"] , :R_LIBS => ENV["R_LIBS"] , :PATH => ENV["PATH"]})
  end

  test do
    system "#{bin}/biobakery_workflows", "--help"
  end
end
