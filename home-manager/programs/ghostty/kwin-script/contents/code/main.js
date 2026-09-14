// Tile new Ghostty windows to the right half of whichever screen they open on.
//
// The half is computed from the window's own output at open time rather than
// stored as absolute pixels, so this follows the window across monitors of
// different resolutions and scales, and keeps clear of panels.

function tileRightHalf(window) {
    if (!window || !window.normalWindow) {
        return;
    }
    if (String(window.resourceClass).toLowerCase().indexOf("ghostty") === -1) {
        return;
    }

    var area = workspace.clientArea(KWin.MaximizeArea, window.output, workspace.currentDesktop);
    var x = area.x + area.width / 2;
    var y = area.y;
    var w = area.width / 2;
    var h = area.height;

    if (typeof Qt !== "undefined" && Qt.rect) {
        window.frameGeometry = Qt.rect(x, y, w, h);
    } else {
        window.frameGeometry = { x: x, y: y, width: w, height: h };
    }
}

workspace.windowAdded.connect(tileRightHalf);
