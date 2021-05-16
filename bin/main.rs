use raster::raster_pdf;
static DUMMY_PDF: &'static [u8] = include_bytes!("../dummy.pdf");

fn main() {
    raster_pdf(DUMMY_PDF, "dummy.jpeg");
}
