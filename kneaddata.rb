class Kneaddata < Formula
  desc "KneadData"
  homepage "http://huttenhower.sph.harvard.edu/kneaddata"
  url "https://pypi.python.org/packages/6d/50/dd20a862b2532a476b4837a2b1fe4f9e8131cf554751adb6fd7186ee33e3/kneaddata-0.5.4.tar.gz"
  version "0.5.4"
  sha256 "c76940de21d3696a6113c51307322c0ff2eadebd62dc980a9923b49d963c26a3"

  # add python dependencies and options
  depends_on :python => :recommended if MacOS.version <= :snow_leopard
  option "with-python3", "Build with python3 instead of python2"
  depends_on :python3 => :optional

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

    ENV.prepend_create_path 'PYTHONPATH', libexec/"lib/python#{python_version}/site-packages"
    system python, *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/kneaddata*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    bin.install Dir[libexec/"bin/*.jar"]
  end

  test do
    system "#{bin}/kneaddata", "--help"
  end
end

