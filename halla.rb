class Halla < Formula
  desc "Halla"
  homepage "https://huttenhower.sph.harvard.edu/halla"
  url "https://pypi.python.org/packages/a4/bc/e00bdc40bd9bb563655cba8c96de0a7bce88efa1a84cbce1611df869dcde/halla-0.7.16.tar.gz"
  version "0.7.16"
  sha256 "ddbbf5e9e871b287e05123425e800c9cbdc1aaa837c8500144e3943e9506ff1a"

  # add the python dependencies and options
  depends_on "python" => :recommended if MacOS.version <= :snow_leopard
  option "with-python3", "Build with python3 instead of python2"
  depends_on "python3" => :optional

  # add the option to not install the numpy/scipy/matplotlib dependencies
  option "without-python-packages", "Don't install the required python packages (numpy/scipy/matplotlib)"
  option "without-numpy", "Don't install numpy"
  option "without-scipy", "Don't install scipy"
  option "without-matplotlib", "Don't install matplotlib"

  resource "numpy" do
    url "https://pypi.python.org/packages/source/n/numpy/numpy-1.11.0.tar.gz"
    sha256 "a1d1268d200816bfb9727a7a27b78d8e37ecec2e4d5ebd33eb64e2789e0db43e"
  end

  resource "matplotlib" do
    url "https://pypi.python.org/packages/source/m/matplotlib/matplotlib-1.5.1.tar.gz"
    sha256 "3ab8d968eac602145642d0db63dd8d67c85e9a5444ce0e2ecb2a8fedc7224d40"
  end

  resource "scipy" do
    url "https://pypi.python.org/packages/05/5e/973bf71cfa865d962a68893e35e366a0a7ac0b713bc398b4e584c1bed982/scipy-0.17.1.tar.gz"
    sha256 "9c4cd2f8013cc4084230a0e858d7642963dbadfd76494d2fad3b0b29bebb38ac"
  end

  resource "pandas" do
    url "https://pypi.python.org/packages/11/09/e66eb844daba8680ddff26335d5b4fead77f60f957678243549a8dd4830d/pandas-0.18.1.tar.gz"
    sha256 "d2e483692c7915916dffd1b83256ea9761b4224c8d45646ceddf48b977ee77b2"
  end

  resource "scikit" do
    url "https://pypi.python.org/packages/0d/1d/9c775f9403565f68aa23f9cef76c817a7115abd7ca1e1c5958a68c49fb6f/scikit-learn-0.17.1.tar.gz"
    sha256 "9f4cf58e57d81783289fc503caaed1f210bab49b7a6f680bf3c04b1e0a96e5f0"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/ad/30/5ab2298c902ac92fdf649cc07d1b7d491a241c5cac8be84dd84464db7d8b/pytz-2016.4.tar.gz"
    sha256 "c823de61ff40d1996fe087cec343e0503881ca641b897e0f9b86c7683a0bfee1"
  end

  resource "dateutil" do
    url "https://pypi.python.org/packages/3e/f5/aad82824b369332a676a90a8c0d1e608b17e740bbb6aeeebca726f17b902/python-dateutil-2.5.3.tar.gz"
    sha256 "1408fdb07c6a1fa9997567ce3fcee6a337b39a503d80699e0f213de4aa4b32ed"
  end

  resource "pyparsing" do
    url "https://pypi.python.org/packages/94/51/3dd26b41be55ed05e72d1da87e4a732d8b92245b1f2f7fe2fa65a4910858/pyparsing-2.1.1.tar.gz"
    sha256 "9bae5cd4cbee6da0d7d8d9a1647f5253a3b89652e707647eaf1961f4932ae6c6"
  end

  resource "cycler" do
    url "https://pypi.python.org/packages/c2/4b/137dea450d6e1e3d474e1d873cd1d4f7d3beed7e0dc973b06e8e10d32488/cycler-0.10.0.tar.gz"
    sha256 "cd7b2d1018258d7247a71425e9f26463dfb444d411c39569972f4ce586b0c9d8"
  end

  resource "minepy" do
    url "https://pypi.python.org/packages/0d/32/bb2fde0ab408adeff55ab065d565f7c1e93738f9ddd779deda1adab79c07/minepy-1.1.0.tar.gz"
    sha256 "04e47d21235282dab0247bfab1adc53fd5c7961e99b0ca6cc0691afef90174b0"
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
    unless $?.exitstatus == 0
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

    ENV.prepend_create_path 'PYTHONPATH', libexec/"lib/python#{python_version}/site-packages"
    ENV.prepend_create_path 'PYTHONPATH', libexec/"vendor/lib/python#{python_version}/site-packages"
    ENV.prepend_create_path 'PYTHONPATH', libexec/"vendor/lib64/python#{python_version}/site-packages"
   
    if build.with? "python-packages"
      # install dependencies if set
      if build.with? "numpy"
        # update LDFLAGS for numpy install
        ENV.append "LDFLAGS", "-shared" if OS.linux?
        resource("numpy").stage do
          system python, *Language::Python.setup_install_args(libexec)
        end
      end

      if build.with? "scipy"
        resource("scipy").stage do
          system python, *Language::Python.setup_install_args(libexec)
        end
      end

      if build.with? "matplotlib"
        %w[matplotlib pyparsing pytz dateutil cycler].each do |r|
          resource(r).stage do
            system python, *Language::Python.setup_install_args(libexec)
          end
        end
      end

      # install dependencies
      for python_package in ["pandas", "scikit", "pyparsing", "minepy"]
          resource(python_package).stage do
              system python, *Language::Python.setup_install_args(libexec/"vendor")
          end
      end
    end

    system python, *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/halla", "--help"
  end
end

