fn main() {
    println!("cargo:rustc-link-lib=dylib=pdfium");
    println!("cargo:rustc-link-search=native=/usr/local/lib");
}
