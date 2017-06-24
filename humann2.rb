class Humann2 < Formula
  desc "HUMAnN2: The HMP Unified Metabolic Analysis Network 2"
  homepage "http://huttenhower.sph.harvard.edu/humann2"
  url "https://pypi.python.org/packages/71/70/9c45436b6dab38706826a822411d6386376205d9c9fa53972e2ff3b7dda8/humann2-0.9.9.tar.gz"
  version "0.9.9"
  sha256 "1193f799b7a976f2212df0351b1cbbd050a186485bd55da1c0a684468242c936"

  # add the python dependencies and options
  depends_on :python => :recommended if MacOS.version <= :snow_leopard
  option "with-python3", "Build with python3 instead of python2"
  depends_on :python3 => :optional

  # humann2 requires metaphlan2 as a dependency
  depends_on "biobakery/biobakery/metaphlan2" => :recommended

  # add the option to not install the numpy/scipy/matplotlib dependencies
  option "without-dependencies", "Don't install the dependencies (numpy,scipy,matplotlib)"

  resource "numpy" do
    url "https://pypi.python.org/packages/67/ab/41e4b42e0519d868347d2cf1051a05ce0170632039c053dee8ffe8b43b0b/numpy-1.8.2.tar.gz"
    sha256 "6d487fc724780d66746bde264ea71f5cd77d3a39e52ee2b073dcaed63bc669db"
  end

  resource "scipy" do
    url "https://pypi.python.org/packages/17/4c/3c01634c5332e1969a27fe5b249fc72a9e79c178f841aedc2635bcf61dee/scipy-0.14.1.tar.gz"
    sha256 "ab75f161107ee411c054abc35e28ec2d19bb5ec8437aaf6c32b80916568f7dad"
  end

  resource "matplotlib" do
    url "https://pypi.python.org/packages/08/4c/f6ef52c64f6d6f81c55e836be541cb23bb2f9d54693dbc7b598453ab0614/matplotlib-1.4.2.tar.gz"
    sha256 "17a3c7154f152d8dfed1f37517c0a8c5db6ade4f6334f684989c36dab84ddb54"
  end

  # add dependencies for matplotlib
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

    # set PYTHONPATH to location where package will be installed (relative to homebrew location)
    ENV.prepend_create_path 'PYTHONPATH', libexec/"lib/python#{python_version}/site-packages"
    ENV.prepend_create_path 'PYTHONPATH', libexec/"lib64/python#{python_version}/site-packages"

    # install dependencies if set
    if build.with? "dependencies"
      # update LDFLAGS for numpy install
      ENV.append "LDFLAGS", "-shared" if OS.linux?
      %w[numpy scipy pyparsing pytz dateutil cycler six matplotlib].each do |r|
        resource(r).stage do
          system python, *Language::Python.setup_install_args(libexec)
        end
      end
    end

    # run python setup.py install using recommended homebrew helper method with destination prefix of libexec
    system python, *Language::Python.setup_install_args(libexec)
    # copy all of the installed scripts to the homebrew bin
    bin.install Dir[libexec/"bin/*"]

    # write stubs to bin that set PYTHONPATH and call executables, move executables back to original location
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/humann2", "--help"
  end
end

