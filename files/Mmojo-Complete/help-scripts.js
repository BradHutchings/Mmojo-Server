// Copyright 2024-26 Brad Hutchings. 
// All Rights Reserved.
// License Inquiries: brad@BradHutchings.com.

var elements = {};

var instructions = 
    "<h3>Shortcuts for the Work Area:</h3>\n" +
    "<p>These shortcuts are designed for desktop interaction, but also work if you have a physical keyboard attached to " +
        "your mobile device.</p>" +
    "<ul>\n" +
        "<li>Hit the <b>RETURN</b> or <b>ENTER</b> key to start completing.</li>\n" + 
        "<li>Type <b>SHIFT-RETURN</b> or <b>SHIFT-ENTER</b> to make a new line in the <b>Work Area</b>.</li>\n" +
        "<li>Type <b>CTRL-RETURN</b> or <b>CTRL-ENTER</b> to make a new line in the Work Area and start completing. " +
            "This is useful when chatting using your name as a stop word.</li>\n" +
        "<li><b>CTRL-Click</b> (Windows and Linux) or <b>OPTION-Click</b> (Mac) to delete everything after the place you click. " +
            "This is useful for backing up and redoing the completed text.</li>\n" +
        "<li><b>CTRL-Z</b> and <b>SHIFT-CTRL-Z</b> undo and redo, respectively, to and from previous completion points.</li>\n" +
        "<li>Click the <b>Copy</b> and <b>Paste</b> buttons at the right to save your work and switch between it.</li>\n" +
        "<li>The number of tokens in the Work Area and available in the model's context window are shown in the <b>Status</b> " +
            "area, bottom right.</li>\n" +
    "</ul>\n" +


    "<hr />\n" +
    "<h3>Icons (Top Right):</h3>\n" +
    "<ul>\n" +
        "<li><img src=\"images/settings-64.png\" class=\"inline-image\" /><b>Settings:</b> Shows <b>Settings</b> panel.\n" + 
        "<ul>\n" +
            "<li>Show and hide the copy / paste controls.</li>\n" +
            "<li>Set temperature, tokens, and stop words.</li>\n" +
        "</ul>\n" +
        "<li><img src=\"images/tools-64.png\" class=\"inline-image\" /><b>Tools:</b> Shows <b>Information</b> panel and <b>Tools</b> panel.</li>\n" + 
        "<li><img src=\"images/help-64.png\" class=\"inline-image\" /><b>Help:</b> You found this page!</li>\n" + 
    "</ul>\n" +

    "<hr />\n" +
    "<h3>Information Panel:</h3>\n" +
    "<ul>\n" +
        "<li><b>Model</b> indicates which model Mmojo Server is using.</li>\n" +
        "<li><b>Mmojo Server</b> indicates when your Mmojo Server application and Mmojo Complete were built.</li>\n" +
    "</ul>\n" +

    "<hr />\n" +
    "<h3>Tools Panel:</h3>\n" +
    "<ul>\n" +
        "<li><img src=\"images/chat-64.png\" class=\"inline-image\" /><b>Chat:</b> Click for a more standard chat-style interface.</li>\n" + 
        "<li><img src=\"images/read-64.png\" class=\"inline-image\" /><b>Read:</b> Click to have the computer read the (selected) Work Area text.</li>\n" + 
        "<li><img src=\"images/download-64.png\" class=\"inline-image\" /><b>Download:</b> Click to download the Work Area text.</li>\n" + 
        "<li><img src=\"images/print-64.png\" class=\"inline-image\" /><b>Print:</b> Click to show the <b>Print</b> panel.</li>\n" + 
        "<li><img src=\"images/bookmark-64.png\" class=\"inline-image\" /><b>Bookmark:</b> Click to open the Bookmark Maker.</li>\n" + 
        "<li><img src=\"images/fullscreen-64.png\" class=\"inline-image\" /><b>Full Screen:</b> Toggle between full screen and window display.</li>\n" +
    "</ul>\n" +

    "<hr />\n" +
    "<h3>Print Panel:</h3>\n" +
    "<ul>\n" +
        "<li><b>Print Size</b>, <b>Picture Width</b>, and <b>Picture URL</b> are for printing.</li>\n" +
        "<li>To print what's in the Work Area, print the page.</li>\n" +
    "</ul>\n" +

    "<hr />\n" +
    "<h3>Mmojo Knowledge Appliance: Change the Model:</h3>\n" +
    "<p>If you are running Mmojo Server on a Mmojo Knowledge Appliance, you can use the Mmojo Controls page to change which large language " +
        "model Mmojo Server uses:</p>\n" +
    "<ul>\n" +
    "<li><a href=\"/controls\" target=\"_blank\">Mmojo Controls</a></li>\n" +
    "</ul>\n" +

    "<hr />\n" +
    "<h3>Mmojo Knowledge Appliance: Install Our Certificate Authority:</h3>\n" +
    "<p>To remove security warnings for the Mmojo Knowledge Appliance on your devices and to allow the Mmojo app to install on " +
        "your phones and tablets, please download and install our Certificate Authority on your devices.</p>\n\n" +
    "<ul>\n" +
    "<li><a href=\"/CA.crt\" >Mmojo Certificate Authority</a></li>\n" +
    "</ul>\n\n" +
    "<p><i>Please install our Certificate Authority only on devices that you own and control.</i></p>\n\n" +

    "<hr />\n" +
    "<h3>More Information:</h3>\n" +
    "For more information and updates, please visit:\n\n" +
    "<ul>\n" +
    "<li><a href=\"https://Mmojo.net\" target=\"_blank\">https://Mmojo.net</a></li>\n" +
    "</ul>\n" +
    "<div style=\"height: 2rem;\"></div>\n\n";

function PageLoaded() {
    FindElements();

    elements.workAreaTextInner.innerHTML = instructions;

}

function FindElements() {
    elements.body                   = document.body;
    elements.content                = document.getElementById("content");
    elements.print                  = document.getElementById("print");
    elements.printContent           = document.getElementById("print-content");

    elements.titleBar               = document.getElementById("title-bar");
    elements.workAreaText           = document.getElementById("work-area-text");
    elements.workAreaTextInner      = document.getElementById("work-area-text-inner");
}

function LoadPrint() {
    elements.printContent.innerHTML = elements.workAreaTextInner.innerHTML;
    // elements.printContent.style.fontSize = printSize;
}
