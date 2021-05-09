use image::ImageBuffer;
use pdfium_rs::Library;
static DUMMY_PDF: &'static [u8] = include_bytes!("../dummy.pdf");

fn main() {
    let library = Library::init().unwrap();
    let document = library.document_from_bytes(DUMMY_PDF).unwrap();
    let page = document.page(0).unwrap();

    // Create white image
    let mut image = ImageBuffer::from_pixel(
        page.width().round() as u32,
        page.height().round() as u32,
        Bgra::<u8>([0xFF; 4]),
    );
    let layout = image.sample_layout();
    let (width, height) = image.dimensions();
    let mut buffer = image.as_flat_samples_mut();
    let buffer = buffer.image_mut_slice().unwrap();

    let mut bitmap = library
        .bitmap_from_external_buffer(
            width as usize,
            height as usize,
            layout.height_stride,
            BitmapFormat::BGRA,
            buffer,
        )
        .unwrap();

    page.render_to(&mut bitmap);

    drop(bitmap);
}
