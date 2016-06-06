class Halla < Formula
  desc "Halla"
  homepage "https://huttenhower.sph.harvard.edu/halla"
  url "https://bitbucket.org/biobakery/halla/get/e1b4d2cf92f4.tar.gz"
  version "0.6.1-dev-e1b4d2cf92f4"
  sha256 "9ef72f149e64676c54fd7eaae780d497b398f62b8d9b90bcb15e0b16745bc422"

  # add the option to build without python
  option "without-python", "Build without python2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard

  # matplotlib on some platforms requires homebrew freetype
  depends_on "freetype" => :recommended

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

  def install
    ENV.prepend_create_path 'PYTHONPATH', libexec/"lib/python2.7/site-packages"
    ENV.prepend_create_path 'PYTHONPATH', libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path 'PYTHONPATH', libexec/"vendor/lib64/python2.7/site-packages"
    
    # update LDFLAGS for numpy install
    ENV.append "LDFLAGS", "-shared" if OS.linux?
    # install dependencies
    for python_package in ["numpy","scipy","matplotlib","pandas","scikit", "pytz"]
        resource(python_package).stage do
            system "python", *Language::Python.setup_install_args(libexec/"vendor")
        end
    end

    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/halla", "--help"
  end
end

