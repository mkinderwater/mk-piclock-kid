import {mountImageLibrary} from '/assets/js/image-library.js?v=1.9.14-rpi-zero-r3';

export function mount(ctx) {
    return mountImageLibrary(ctx, {
        heading: 'Bedtime images',
        labelSingular: 'bedtime image',
        labelPlural: 'bedtime images',
        description: 'Add calm pictures used only during bedtime hours.',
        emptyText: 'No bedtime images yet. Add PNG files above.',
        listUrl: '/api/v1/assets/bedtime-images',
        uploadUrl: '/api/v1/assets/bedtime-images/upload',
        deleteUrl: '/api/v1/assets/bedtime-images/delete',
        deleteAllUrl: '/api/v1/assets/bedtime-images/delete-all',
        downloadUrl: '/api/v1/assets/bedtime-images/download',
        downloadLabel: 'Download all bedtime PNGs',
        downloadFilename: 'mk-piclock-bedtime-images-png.zip'
    });
}
