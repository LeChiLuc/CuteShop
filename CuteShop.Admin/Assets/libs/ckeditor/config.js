/**
 * @license Copyright (c) 2003-2017, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
    // config.uiColor = '#AADC6E';
    config.allowedContent = {
        $1: {
            // Use the ability to specify elements as an object.
            elements: CKEDITOR.dtd,
            attributes: true,
            styles: true,
            classes: true
        }
    };
    config.disallowedContent = 'script; *[on*]';
    config.filebrowserBrowseUrl = '/Assets/libs/ckfinder/ckfinder.html',
    config.filebrowserUploadUrl = '/Assets/libs/ckfinder/core/connector/aspx/connector.aspx?command=QuickUpload&type=Files',
    config.filebrowserImageUploadUrl = '/UploadedFiles';
    config.filebrowserFlashUploadUrl = '/Assets/libs/ckfinder/core/connector/aspx/connector.aspx?command=QuickUpload&type=Flash';
    config.filebrowserWindowWidth = '1000',
    config.filebrowserWindowHeight = '1000'
};
