use image::{Bgra, ImageBuffer};
use pdfium_rs::{BitmapFormat, Library};
static DUMMY_PDF: &'static [u8] = include_bytes!("../dummy.pdf");

fn main() {
    // initialize library
    let library = Library::init().unwrap();

    // load document
    let document = library.document_from_bytes(DUMMY_PDF).unwrap();

    // load page
    let page = document.page(0).unwrap();

    // get width and height of the page
    let width = page.width().round() as u32;
    let height = page.height().round() as u32;

    // create white image
    let mut image = ImageBuffer::from_pixel(width, height, Bgra::<u8>([0xFF; 4]));

    // get image's buffer
    let layout = image.sample_layout();
    let (width, height) = image.dimensions();
    let mut buffer = image.as_flat_samples_mut();
    let buffer = buffer.image_mut_slice().unwrap();

    // create bitmap
    let mut bitmap = library
        .bitmap_from_external_buffer(
            width as usize,
            height as usize,
            layout.height_stride,
            BitmapFormat::BGRA,
            buffer,
        )
        .unwrap();

    // render pdf
    page.render_to(&mut bitmap);
    // drop the bitmap so that you can access the image again
    drop(bitmap);

    // there is at least one none white pixel
    // assert!(image.pixels().any(|x| *x != Bgra::<u8>([0xFF; 4])));
    image.save("dummy.jpeg").unwrap();
}
