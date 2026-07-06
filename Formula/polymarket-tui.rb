class PolymarketTui < Formula
  desc "Terminal client for Polymarket prediction markets"
  homepage "https://github.com/byronxlg/polymarket-tui"
  url "https://files.pythonhosted.org/packages/86/f1/11f5f1943d5b7b853b5d973be0bd9ab112665c227e22cd6c718269122e24/polymarket_tui-0.1.1.tar.gz"
  sha256 "3cc7540c5319a5da713ad56ae85699bb1506e05fc0067f50d328c65252df0c62"
  license "MIT"
  head "https://github.com/byronxlg/polymarket-tui.git", branch: "main"

  depends_on "python@3.12"

  def install
    python = formula_opt_bin("python@3.12")/"python3.12"
    system python, "-m", "venv", libexec
    # Personal tap: dependencies resolve from PyPI at install time rather than
    # being vendored as homebrew-core-style resource blocks. The stable url
    # tracks the published PyPI release; `brew install --HEAD` tracks main.
    system libexec/"bin/pip", "install", "--quiet", "--upgrade", "pip"
    system libexec/"bin/pip", "install", "--quiet", buildpath.to_s
    bin.install_symlink libexec/"bin/polymarket-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/polymarket-tui --version")
  end
end
