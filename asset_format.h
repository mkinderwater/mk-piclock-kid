#ifndef MK_PICLOCK_ASSET_FORMAT_H
#define MK_PICLOCK_ASSET_FORMAT_H

/* Clock artwork has one canonical source format: 128x64 RAW8 grayscale.
 * OLED conversion to 4-bit occurs only after the final resize. */
#define MP_IMAGE_WIDTH 128
#define MP_IMAGE_HEIGHT 64
#define MP_IMAGE_RAW_BYTES (MP_IMAGE_WIDTH * MP_IMAGE_HEIGHT)

#define MP_IMAGE_RAW_SIZE_VALID(size_value) \
    ((size_value) == MP_IMAGE_RAW_BYTES)

#endif
