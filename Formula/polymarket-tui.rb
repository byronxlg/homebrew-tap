class PolymarketTui < Formula
  desc "Terminal client for Polymarket prediction markets"
  homepage "https://github.com/byronxlg/polymarket-tui"
  url "https://files.pythonhosted.org/packages/dc/2e/d9e0bd3de7caa578ce5612f7bb4510d6d99e8cd13098ad95f64dcdf24bf9/polymarket_tui-0.1.2.tar.gz"
  sha256 "ae492541605fc8208c44eb7e9fab7651fe982d82e6cac2a9e613ff731d4d9966"
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
