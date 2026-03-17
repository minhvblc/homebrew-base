class Base < Formula
  desc "Internal SwiftUI app scaffolder"
  homepage "https://github.com/minhvblc/BaseProject"
  url "https://github.com/minhvblc/BaseProject.git",
      tag:      "0.1.4",
      revision: "8fcf1ded370990e9fb3ed9d56a3cfb95f98ce5bb"
  version "0.1.4"
  license :cannot_represent

  depends_on "xcodegen"
  depends_on "cocoapods"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release", "--product", "base", "--package-path", "base-cli"
    bin.install "base-cli/.build/release/base"

    template_root = share/"base-cli/template"
    template_root.mkpath
    FileUtils.cp_r(
      Dir["base-template/{*,.*}"].reject { |path| [".", ".."].include?(File.basename(path)) },
      template_root
    )
  end

  def caveats
    <<~EOS
      Optional:
        brew install swiftlint
    EOS
  end

  test do
    output_path = testpath/"SmokeApp"
    system bin/"base", "new",
      "--app-name", "Smoke App",
      "--target-name", "SmokeApp",
      "--bundle-id", "com.example.smokeapp",
      "--with-cocoapods",
      "--output", output_path,
      "--skip-generate",
      "--skip-pod-install",
      "--no-input"

    assert_path_exists output_path/"project.yml"
    assert_path_exists output_path/"Podfile"
    assert_match "name: SmokeApp", (output_path/"project.yml").read
  end
end
