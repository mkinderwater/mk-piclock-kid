import {mountImageLibrary} from '/assets/js/image-library.js?v=1.9.17-rpi-zero-r3';

export function mount(ctx) {
    return mountImageLibrary(ctx, {
        heading: 'Day images',
        labelSingular: 'image',
        labelPlural: 'day images',
        description: 'Add pictures the clock can show during the day. PNG files work best.',
        emptyText: 'No day images yet. Add PNG files above.',
        listUrl: '/api/v1/assets/images',
        uploadUrl: '/api/v1/assets/images/upload',
        deleteUrl: '/api/v1/assets/images/delete',
        deleteAllUrl: '/api/v1/assets/images/delete-all',
        downloadUrl: '/api/v1/assets/images/download',
        downloadLabel: 'Download all day PNGs',
        downloadFilename: 'mk-piclock-day-images-png.zip'
    });
}
