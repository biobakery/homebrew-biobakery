class Kneaddata < Formula
  desc "KneadData"
  homepage "http://huttenhower.sph.harvard.edu/kneaddata"
  url "https://pypi.python.org/packages/f8/6a/3c8f200d3088c5bc0dd2c85b74d5199e3ca1f2fb7d8baae44708f5b1b928/kneaddata-0.6.1.tar.gz"
  version "0.6.1"
  sha256 "46540a22bebc84919a71138c419c69f68e9f5e35404587a2e31a3a3e53c66077"

  # add python dependencies and options
  depends_on "python" => :recommended if MacOS.version <= :snow_leopard
  option "with-python3", "Build with python3 instead of python2"
  depends_on "python3" => :optional

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

    # Add brew bin since it is no longer included in PATH
    ENV.prepend 'PATH', File.join(HOMEBREW_PREFIX,'bin'), ':'

    ENV.prepend_create_path 'PYTHONPATH', libexec/"lib/python#{python_version}/site-packages"
    system python, *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/kneaddata*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    bin.install Dir[libexec/"bin/*.jar"]
    # if bowtie2 is installed, then move to bin
    if !Dir[libexec/"bin/bowtie2*"].empty?
      bin.install Dir[libexec/"bin/bowtie2*"]
    end
  end

  test do
    system "#{bin}/kneaddata", "--help"
  end
end

