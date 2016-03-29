class Humann2 < Formula
  desc "HUMAnN2: The HMP Unified Metabolic Analysis Network 2"
  homepage "http://huttenhower.sph.harvard.edu/humann2"
  url "https://pypi.python.org/packages/source/h/humann2/humann2-0.7.0.tar.gz"
  version "0.7.0"
  sha256 "fab0438ac037a2843d2d7ffa74a8f113e3a299144c6cfdc4a100cc16eebed274"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end
end

