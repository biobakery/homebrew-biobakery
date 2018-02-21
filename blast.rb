class Blast < Formula
  desc "Basic Local Alignment Search Tool"
  homepage "http://blast.ncbi.nlm.nih.gov/"
  version "2.3.0"

  # add the option to build from source
  option "with-source", "Build blast from source (default installs compiled binaries)"

  if OS.linux? and not build.with? "source"
      url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.3.0/ncbi-blast-2.3.0+-x64-linux.tar.gz"
      sha256 "eef6f4cd88b597d80d04b97c42d8a0e82b24034b715d1627a7fbededb222d6c0"
  elsif build.with? "source"
      url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.3.0/ncbi-blast-2.3.0+-src.tar.gz"
      sha256 "7ce8dc62f58141b6cdcd56b55ea3c17bea7a672e6256dfd725e6ef94825e94e9"
  else
      url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.3.0/ncbi-blast-2.3.0+-universal-macosx.tar.gz"
      sha256 "5be45df95d815f7a99d9d05d7626166e610a2950f907d859725b595832fa3be9"
  end

  def install
    if build.with? "source"
      cd "c++" do
        system "./configure", "--prefix=#{prefix}", "--libdir=#{libexec}"
        system "make"
        system "make", "install"
      end
    else
      prefix.install Dir["*"] 
    end    
  end

  test do
    system "blastn", "-version"
  end
end
