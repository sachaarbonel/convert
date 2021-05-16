mod raster;
use raster::raster;
extern crate libc;

use libc::size_t;
use std::slice;

use libc::c_char;
use std::ffi::CStr;

#[no_mangle]
pub extern "C" fn raster_pdf(
    data: *const u8,
    size: size_t,
    path: *const c_char,
    pages: *const i32,
    pages_len: size_t,
) {
    let buffer = unsafe {
        assert!(!data.is_null());

        slice::from_raw_parts(data, size as usize)
    };
    let path_cstr = unsafe {
        assert!(!path.is_null());

        CStr::from_ptr(path)
    };
    let pages = unsafe {
        assert!(!pages.is_null());

        slice::from_raw_parts(pages, pages_len as usize)
    };

    let path_str = path_cstr.to_str().unwrap();
    raster(buffer, path_str, pages);
}
