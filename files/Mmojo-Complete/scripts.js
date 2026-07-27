/*
#  This is an original source file for the Mmojo Server repo. It is covered by
#  the repo's MIT-style LICENSE:
#
#  https://github.com/BradHutchings/Mmojo-Server/blob/main/LICENSE
#
#  Copyright (c) 2025-26 Brad Hutchings.
#  --
#  Brad Hutchings
#  brad@Mmojo.net
*/

const isMmojoPage = true;
const kLogging = false;
const kMaxCopyPastes = 20;
const kUpdated = '[[UPDATED]]';
const kWaitToComplete = 2000;
const kReplayDelay = 25;

// const kServerURL = "http://llama-cpp:8000";
// const kServerURL = "http://llama-cpp:8000";
// const kServerURL = "http://LlamaCppDesktop:8000";
const kServerURL = "";
const kCompletionsURL = kServerURL + "/completion";
const kModelsURL = kServerURL + "/v1/models"
const kTokenizeURL = kServerURL + "/tokenize"

const kMmojoComplete = "Mmojo Complete is Private.";

const kStatusMode = Object.freeze({
    preparing:				1,      // page loading, not ready for editing.
    editing:                2,      // work area is being edited.
    evaluating:             3,      // start of evaulating.
    evaluating_progress:    4,      // evaluating has sent progress.
    evaluating_finishing:   5,      // finishing with prompt - last batch?.
    completing:             6,      // generating new tokens.
    completed:              7,      // show completion time in status prior to any editing.
    stopped_by_word:        8,
    stopped_after:          9,
    stopped_by_user:        10,
	ready_to_replay:		11,
    replaying:              12,
    error:                  13,
});

const kStatusText = Object.freeze({
    preparing:              	"Preparing.",
    editing_empty:				"Awaiting your cue.",
    editing_ready_to_complete:  "Ready to complete.",
    evaluating:             	"Evaluating.",
    evaluating_progress:    	"Evaluating ",
    evaluating_finishing:   	"Finishing evaluating.",
    completing:             	"Completing.",
    completed:              	"Completed in [elapsed_time].",
    stopped_by_word:        	"Stopped by \"[word]\".",
    stopped_after:          	"Stopped after [tokens_predicted] tokens.",
    stopped_by_user:        	"Stopped by you.",
	ready_to_replay:			"Ready to replay.",
    replaying:              	"Replaying.",
    error:                  	"Error.",
});

const kModeCueLink = "cue-link";
const kModeCueScript = "cue-script";
const kModeAppend = "append";
const kModePrepend = "prepend";
const kModePaste = "paste";
const kModeReplace = "replace";
const kModeReplaceRegEx = "replace-regex";
const kModes = [kModeCueLink, kModeCueScript, kModeAppend, kModePrepend, kModePaste, kModeReplace, kModeReplaceRegEx];
const kLinkModes = [kModeCueLink];
const kScriptModes = [kModeCueScript, kModeAppend, kModePrepend, kModePaste, kModeReplace, kModeReplaceRegEx];

const kWorkAreaTextPlaceholder = 
    "Welcome to Mmojo Complete, delivered to you from your own Mmojo Server. " +
    "Anything you do with LLMs in the cloud, you can do here, privately.\n\n" +
    "Type some text in this work area that will get the language model started. The " +
	"text you type is called a \"cue\".\n\n" +
    "Once you've entered your cue, click the Start button at the bottom or hold down " + 
	"the SHIFT key and type the ENTER key to start completing.\n\n" +
    "Remember: You are intelligent. LLMs do not think. Chat is an illusion.\n\n" +
    "Click the ? button (top-right) for more help.";

const kCompletionMinimumTimeMS = 1500;

var kHelpHTML = 
    "<h3>Shortcuts for the Work Area:</h3>\n" +
    "<p>These shortcuts are designed for desktop interaction, but also work if you have a physical keyboard attached to " +
        "your mobile device.</p>" +
    "<ul>\n" +
        "<li>Hold down the <b>SHIFT</b> key and type the <b>RETURN</b> or <b>ENTER</b> key to start completing.</li>\n" + 
        "<li>Type <b>CTRL-SHIFT-RETURN</b> or <b>CTRL-SHIFT-ENTER</b> to make a new line in the Work Area and start completing. " +
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
            "<li>Choose a theme. You can also hold down the <b>SHIFT</b> key and click the <b>Settings</b> icon to cycle through themes.</li>\n" +
        "</ul>\n" +
        "<li><img src=\"images/tools-64.png\" class=\"inline-image\" /><b>Tools:</b> Shows <b>Information</b> panel and <b>Tools</b> panel.</li>\n" + 
        "<li><img src=\"images/files-64.png\" class=\"inline-image\" /><b>Files:</b> Shows <b>Files</b> panel when work area contains markdown files.</li>\n" + 
        "<li><img src=\"images/help-64.png\" class=\"inline-image\" /><b>Help:</b> You found this panel!</li>\n" + 
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
        "<li><img src=\"images/bookmark-64.png\" class=\"inline-image\" /><b>Bookmark:</b> Click to show the <b>Bookmark</b> panel.</li>\n" + 
        "<li><img src=\"images/fullscreen-64.png\" class=\"inline-image\" /><b>Full Screen:</b> Toggle between full screen and window display.</li>\n" +
    "</ul>\n" +

    "<hr />\n" +
    "<h3>Print Panel:</h3>\n" +
    "<ul>\n" +
        "<li><b>Print Size</b>, <b>Picture Width</b>, and <b>Picture URL</b> are for printing.</li>\n" +
        "<li>To print what's in the Work Area, print the page.</li>\n" +
    "</ul>\n" +

    "<hr />\n" +
    "<h3>Mmojo Appliance: Change the Model:</h3>\n" +
    "<p>If you are running Mmojo Server on a Mmojo Appliance, you can use the Mmojo Controls page to change which large language " +
        "model Mmojo Server uses:</p>\n" +
    "<ul>\n" +
    "<li><a href=\"/controls\" target=\"_blank\">Mmojo Controls</a></li>\n" +
    "</ul>\n" +

    "<hr />\n" +
    "<h3>Mmojo Appliance: Install Our Certificate Authority:</h3>\n" +
    "<p>To remove security warnings for the Mmojo Appliance on your devices and to allow the Mmojo app to install on " +
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

const isMmojoBookmarkPage = true;
var bookmarkTextChanged = true;

const kBookmarksCompletedTextPlaceholder = 
    "The Bookmark Maker makes web browser bookmarks and links for automating Mmojo Complete.\n\n" +
    "The settings are in the olive area at top:\n" +
    "    - Label lets you set the label for the bookmark so you don't have to rename it.\n" +
    "    - Temperature, Tokens, and Stop Words work as they do in Mmojo Complete Tool.\n" +
    "    - If the Auto-Complete checkbox is checked, opening the bookmark will cause the model to automatically start completing.\n" +
    "    - Append will append the cue to what's in the work area. Use to make clarifying bookmarks.\n" +
    "    - Replace will update the work area text, replacing the text in the top peach area with text in the bottom peach area. Use to make clarifying bookmarks.\n" +
    "The top peach area if for your cue.\n\n" +
    "The bottom peach area (this area) is for completed text you wish to play back. You can simulate the model responding with a known response.\n\n" +
    "A bookmark link is continually updated at the top right of the olive area. " +
        "Click the link to open it in a new tab or drag the link to the Bookmarks Bar in your web browser.\n\n" +
    "Updated: " + kUpdated;

var elements = {};                  // Fine to have this in global space.

var script = {};
script.completingController = null;
script.metadata = {};
script.modelName = "";
script.contextWindowSize = 0;
script.lastContentWindowSize = 0;   // For updating the token count.
script.tokenCount = 0;
script.lastTokenCountText = "";
script.isMobile = (navigator.maxTouchPoints > 1) && (window.navigator.userAgent.includes("Mobi"));
script.manualStop = false;
script.completedContent = '';
script.completionStartedMS = 0;
script.completionEndedMS = 0;
script.evaluatingEstimatedMS = 0;
script.evaluatingTokensProcessed = 0;
script.evaluatingTokensTotal = 0;
script.stoppedByWord = "";
script.stoppedAfterTokens = 0;
script.replayText = "";
script.statusMode = kStatusMode.editing;
script.statusMessage = "";
script.hasDirectoryPicker = (typeof window.showDirectoryPicker === "function");
script.directoryHandle = null;

//	REMOVE THESE -Brad 2026-06-11
//	script.completing = false;          // Replace this with a mode: kMode_Typing, kMode_Completing, kMode_Replaying
//	script.replaying = false;

function IsCompleting() {
	var result =
		(script.statusMode === kStatusMode.evaluating) ||
		(script.statusMode === kStatusMode.evaluating_progress) ||
		(script.statusMode === kStatusMode.evaluating_finishing) ||
		(script.statusMode === kStatusMode.completing);

	return result;
}

function IsReplaying() {
	var result = (script.statusMode === kStatusMode.replaying);

	return result;
}

function ShowElement(elt) {
    if (elt.classList.contains("hidden")) {
        elt.classList.remove("hidden");
    }
}

function HideElement(elt) {
    if (!elt.classList.contains("hidden")) {
        elt.classList.add("hidden");
    }
}

function ToggleShowElement(elt) {
    if (elt.classList.contains("hidden")) {
        elt.classList.remove("hidden");
    }
    else {
        elt.classList.add("hidden");
    }
}

function ElementIsShown(elt) {
    let result = !elt.classList.contains("hidden");
    return result;
}

function PageLoaded() {
    FindElements();
    SetCopyPasteScripts();
    ResizeCopyPaste();

    elements.updated.innerText = kUpdated;

    elements.workAreaText.placeholder = kWorkAreaTextPlaceholder;
    elements.workAreaText.value = '';
    WorkAreaFocus();

    elements.helpText.innerHTML = kHelpHTML;
	
    elements.bookmarkCompletedText.placeholder = kBookmarksCompletedTextPlaceholder;

    EnableControls();
    if (script.isMobile) {
        HideElement(elements.bookmarkIcon);
        HideElement(elements.fullscreenIcon);
        HideElement(elements.restoreIcon);
    }

    script.statusMode = kStatusMode.editing;
    ShowHideStatusButtons();

    UseHash();

    setTimeout(function() {
        HideElement(elements.gutter);
        ShowElement(elements.status);
    }, 2000);

    setTimeout(function() {
        GetModelInfoFromServer();
        CountTokens();
    }, 500);

    setInterval(function() {
        UpdateStatus();
    }, 200);

	setInterval(function() {
        ShowHideFilesIcon();
    }, 3000);

	setInterval(function() {
        if (bookmarkTextChanged) {
            // console.log('Text has changed.');
            UpdateBookmark();
        }
    }, 1000);


    var checked = localStorage.getItem('showCopyAndPaste');
    if (checked === "true") {
        elements.showCopyAndPasteCheckbox.checked = true;
    }

	var apiKey = localStorage.getItem('apiKey');
	elements.apiKey.value = apiKey;

	UseTheme();

    EnableControls();
}

function PageResized() {
    // ShowHideModel();
}

function FindElements() {
    elements.body                       = document.body;
    elements.content                    = document.getElementById("content");
    elements.printLayout                = document.getElementById("print-layout");
    elements.printPicture               = document.getElementById("print-picture");
    elements.printContent               = document.getElementById("print-content");

    elements.titleBar                   = document.getElementById("title-bar");
    elements.mmojoComplete        	    = document.getElementById("mmojo-complete");
    elements.settingsIcon               = document.getElementById("settings-icon");
    elements.toolsIcon                  = document.getElementById("tools-icon");
    elements.filesIcon                  = document.getElementById("files-icon");
    elements.helpIcon                   = document.getElementById("help-icon");

    elements.tools                      = document.getElementById("tools");
    elements.model                  	= document.getElementById("model");
    elements.chatIcon                   = document.getElementById("chat-icon");
    elements.readIcon                   = document.getElementById("read-icon");
    elements.downloadIcon               = document.getElementById("download-icon");
    elements.printIcon                  = document.getElementById("print-icon");
    elements.bookmarkIcon               = document.getElementById("bookmark-icon");
    elements.fullscreenIcon             = document.getElementById("fullscreen-icon");
    elements.restoreIcon             	= document.getElementById("restore-icon");

    elements.settings                   = document.getElementById("settings");
    elements.showCopyAndPasteCheckbox   = document.getElementById("show-copy-and-paste-checkbox");
    elements.temperature                = document.getElementById("temperature");
    elements.tokens                     = document.getElementById("tokens");
    elements.stopWordsCheckbox          = document.getElementById("stop-words-checkbox");
    elements.stopWordsBreak             = document.getElementById("stop-words-break");
    elements.stopWordsLabel             = document.getElementById("stop-words-label");
    elements.stopWords                  = document.getElementById("stop-words");
    elements.apiKeyLabel             	= document.getElementById("api-key-label");
    elements.apiKey                  	= document.getElementById("api-key");
    elements.themeLabel             	= document.getElementById("theme-label");
    elements.theme                  	= document.getElementById("theme");
    elements.updated                	= document.getElementById("updated");

    elements.print          			= document.getElementById("print");
    elements.printSize              	= document.getElementById("print-size");
    elements.pictureWidth           	= document.getElementById("picture-width");
    elements.pictureUrlBreak        	= document.getElementById("picture-url-break");
    elements.pictureUrl             	= document.getElementById("picture-url");
    elements.printPrintButton       	= document.getElementById("print-print-button");
    elements.printCancelButton       	= document.getElementById("print-cancel-button");

    elements.workArea               	= document.getElementById("work-area");
    elements.workAreaText           	= document.getElementById("work-area-text");

    elements.copyPaste              	= document.getElementById("copy-paste");    
    elements.copyPasteItem          	= document.getElementById("copy-paste-item");
    elements.copyPasteSpace         	= document.getElementById("copy-paste-space");
    elements.clearCue               	= document.getElementById("clear-cue");
    elements.preview                	= document.getElementById("preview");

	elements.filesArea					= document.getElementById("files-area");
	elements.filesAreaHeader			= document.getElementById("files-area-header");
	elements.filesDirectoryName			= document.getElementById("files-directory-name");
	elements.filesDirectoryChoose		= document.getElementById("files-directory-choose");
	elements.filesDownloadAll			= document.getElementById("files-download-all");
	elements.filesAreaBody				= document.getElementById("files-area-body");
	elements.filesList					= document.getElementById("files-list");
	elements.filesListItemTemplate		= document.getElementById("files-list-item-template");
	elements.fileView					= document.getElementById("file-view");
	elements.fileViewHeader				= document.getElementById("file-view-header");
	elements.fileName					= document.getElementById("file-name");
	elements.fileContents				= document.getElementById("file-contents");
	elements.fileControls				= document.getElementById("file-controls");
	elements.fileCopy					= document.getElementById("file-copy");
	elements.fileDownload				= document.getElementById("file-download");

	elements.helpContainer				= document.getElementById("help-container");
	elements.helpText					= document.getElementById("help-text");

	elements.bookmarkMaker					= document.getElementById("bookmark-maker");
	elements.bookmarkSettings				= document.getElementById("bookmark-settings");
	elements.bookmarkLabel					= document.getElementById("bookmark-label");
	elements.bookmarkLabelSpace				= document.getElementById("bookmark-label-space");
	elements.bookmarkLinkLabel				= document.getElementById("bookmark-link-label");
	elements.bookmarkLink					= document.getElementById("bookmark-link");
	elements.bookmarkTemperatureBreak		= document.getElementById("bookmark-temperature-break");
	elements.bookmarkTemperature			= document.getElementById("bookmark-temperature");
	elements.bookmarkTokens					= document.getElementById("bookmark-tokens");
	elements.bookmarkStopWordsBreak			= document.getElementById("bookmark-stop-words-break");
	elements.bookmarkStopWordsCheckbox		= document.getElementById("bookmark-stop-words-checkbox");
	elements.bookmarkStopWords				= document.getElementById("bookmark-stop-words");
	elements.bookmarkModeBreak				= document.getElementById("bookmark-mode-break");
	elements.bookmarkMode					= document.getElementById("bookmark-mode");
	elements.bookmarkAutoCompleteCheckbox	= document.getElementById("bookmark-auto-complete-checkbox");
	elements.bookmarkClearSpace				= document.getElementById("bookmark-clear-space");
	elements.bookmarkClear					= document.getElementById("bookmark-clear");
	elements.bookmarkCue					= document.getElementById("bookmark-cue");
	elements.bookmarkCueText				= document.getElementById("bookmark-cue-text");
	elements.bookmarkCompleted				= document.getElementById("bookmark-completed");
	elements.bookmarkCompletedText			= document.getElementById("bookmark-completed-text");

    elements.status                 	= document.getElementById("status");
    elements.statusText             	= document.getElementById("status-text");
    elements.statusStart            	= document.getElementById("status-start");
    elements.statusStop             	= document.getElementById("status-stop");
    elements.statusUndo             	= document.getElementById("status-undo");
    elements.statusClear            	= document.getElementById("status-clear");

    elements.gutter                 	= document.getElementById("gutter");
    elements.link                  		= document.getElementById("link");
    elements.copyright              	= document.getElementById("copyright");

    document.addEventListener("fullscreenchange", FullscreenChange);
    document.addEventListener("keydown", KeyPress);
}

function SetCopyPasteScripts() {
    let items = Array.from(elements.copyPaste.getElementsByClassName("copy-paste-item"));
    
    items.forEach((item) => {
        let copyPasteButton = item.getElementsByClassName("copy-paste-button")[0];
        let removeButton = item.getElementsByClassName("remove-button")[0];

        copyPasteButton.addEventListener('click', function(e) {
            HandleCopyPaste(item);
        });

        copyPasteButton.addEventListener('mouseenter', function(e) {
            HandleCopyPasteMouseEnter(item);
        });

        copyPasteButton.addEventListener('mouseleave', function(e) {
            HandleCopyPasteMouseLeave(item);
        });

        removeButton.addEventListener('click', function(e) {
            HandleRemove(item);
        });

    });
}

function HandleCopyPaste(copyPasteItem) {
    WorkAreaFocus();

    if (copyPasteItem.pasteValue !== undefined) {
        if (kLogging) console.log("Pasting.");
        HandleCopyPasteMouseLeave(copyPasteItem);

        elements.workAreaText.value = copyPasteItem.pasteValue.workAreaText;
        WorkAreaFocus();
        ScrollToEnd();

        elements.temperature.value = copyPasteItem.pasteValue.temperature;
        elements.tokens.value = copyPasteItem.pasteValue.tokens;
        elements.stopWordsCheckbox.checked = copyPasteItem.pasteValue.stopWordsCheckbox;
        elements.stopWords.value = copyPasteItem.pasteValue.stopWords;
    }
    else {
        if (kLogging) console.log("Copying.");
        copyPasteItem.pasteValue = {
            workAreaText: elements.workAreaText.value,
            temperature: elements.temperature.value,
            tokens: elements.tokens.value,
            stopWordsCheckbox: elements.stopWordsCheckbox.checked,
            stopWords: elements.stopWords.value
        }
        ResizeCopyPaste();
    }

    EnableControls();
    EnableCopyPaste();
}

function HandleCopyPasteMouseEnter(copyPasteItem) {
    if (kLogging) console.log('HandleCopyPasteMouseEnter');

    if (copyPasteItem.pasteValue !== undefined) {
        let inset = 20;
        let hInset = 8 * inset;
        let vInset = 8 * inset;

        let workAreaTextRect = elements.workAreaText.getBoundingClientRect(); 
        if (kLogging) console.log('workAreaTextRect: ' + workAreaTextRect.left + ", " + workAreaTextRect.top + ", " + workAreaTextRect.width + ", " + workAreaTextRect.height);

        let workAreaTextComputedStyle = getComputedStyle(elements.workAreaText);        
        let previewComputedStyle = getComputedStyle(elements.preview);

        let previewRect = {};
        previewRect.left = workAreaTextRect.left + hInset -
            parseInt(previewComputedStyle.borderLeftWidth.slice(0, -2));

        previewRect.top = workAreaTextRect.top;

        previewRect.width = workAreaTextRect.width - hInset -
            parseInt(previewComputedStyle.paddingLeft.slice(0, -2)) - 
            parseInt(previewComputedStyle.paddingRight.slice(0, -2)) - 
            parseInt(previewComputedStyle.borderRightWidth.slice(0, -2));

        previewRect.height = workAreaTextRect.height - vInset -
            parseInt(previewComputedStyle.paddingTop.slice(0, -2)) - 
            parseInt(previewComputedStyle.paddingBottom.slice(0, -2));

        if (kLogging) console.log('previewRect: ' + previewRect.left + ", " + previewRect.top + ", " + previewRect.width + ", " + previewRect.height);

        elements.preview.style.left = '' + previewRect.left + 'px';
        elements.preview.style.top = '' + previewRect.top + 'px';
        elements.preview.style.width = '' + previewRect.width + "px";
        elements.preview.style.height = '' + previewRect.height + "px";

        let previewText = copyPasteItem.pasteValue.workAreaText;
        previewText = previewText.replace(/\r\n/g, '<br/>');
        previewText = previewText.replace(/\r/g, '<br/>');
        previewText = previewText.replace(/\n/g, '<br/>');
        if (kLogging) console.log('prfeviewText: ' + previewText);

        if (copyPasteItem.pasteValue.stopWordsCheckbox) {
            previewText = '<b>Stop Words:</b> ' + copyPasteItem.pasteValue.stopWords + '\n<br/><hr/>\n' + previewText;
        }

        elements.preview.innerHTML = previewText;
        elements.preview.style.display = 'block';
        elements.preview.style.visibility = 'visible';
    }
}

function HandleCopyPasteMouseLeave(copyPasteItem) {
    if (kLogging) console.log('HandleCopyPasteMouseLeave');

    elements.preview.innerText = '';
    elements.preview.style.display = 'none';
    elements.preview.style.visibility = 'hidden';
}

function HandleRemove(copyPasteItem) {
    WorkAreaFocus();

    if (copyPasteItem.pasteValue !== undefined) {
        if (kLogging) console.log("Removing button.");
        delete copyPasteItem.pasteValue;
    }

    ResizeCopyPaste();
    EnableCopyPaste();
}

function ResizeCopyPaste() {
    let appended = false;
    
    let items = Array.from(elements.copyPaste.getElementsByClassName("copy-paste-item"));

    let notEmptyItems = items.slice(0, -1);     // 2nd to the last.

    // These items should not be empty.
    notEmptyItems.forEach((item) => {
        if (item.pasteValue === undefined) {
            item.remove();
        }
    });

    if ((items.length > 0) && (items.length < kMaxCopyPastes)) {
        let lastItem = items.at(-1);
        if (lastItem.pasteValue !== undefined) {
            let firstItem = items.at(0);
            let clone = firstItem.cloneNode(true);
            if (clone.pasteValue !== undefined) {
                delete clone.pasteValue;
            }
            elements.copyPaste.insertBefore(clone, elements.copyPasteSpace);
            appended = true;
        }
    }

    if (appended) {
        SetCopyPasteScripts();
    }
}

function ClearCue() {
    let workAreaText = elements.workAreaText.value;

    if ((script.completedContent != '') && (workAreaText.endsWith(script.completedContent))) {
        elements.workAreaText.value = script.completedContent.trimStart();
        WorkAreaFocus();
        script.completedContent = "";
        EnableCopyPaste();
        PushChange();
    }
}

function ClearWorkArea() {
    elements.workAreaText.value = '';
    WorkAreaFocus();

    ClearUndoRedoStack();
    ShowHideStatusButtons();
    script.statusMode = kStatusMode.editing;
}

function EnableControls(event) {
    if ((event !== undefined) && (event !== null)) {
        event.stopPropagation();
    }

    if (elements.stopWordsCheckbox.checked) {
        if (kLogging) console.log("Enabling stop words.");
        
        ShowElement(elements.stopWordsBreak);
        ShowElement(elements.stopWordsLabel);
        ShowElement(elements.stopWords);
    }
    else {
        if (kLogging) console.log("Disabling stop words.");
        HideElement(elements.stopWordsBreak);
        HideElement(elements.stopWordsLabel);
        HideElement(elements.stopWords);
    }

    if (elements.showCopyAndPasteCheckbox.checked) {
        ShowElement(elements.copyPaste);
    }
    else {
        HideElement(elements.copyPaste);
    }

    EnableCopyPaste();
}

function ShowCopyAndPasteChanged(event) {
    if ((event !== undefined) && (event !== null)) {
        event.stopPropagation();
    }

    if (elements.showCopyAndPasteCheckbox.checked) {
        localStorage.setItem('showCopyAndPaste', 'true');
        if (kLogging) console.log("Set showCopyAndPaste true.");
    }
    else {
        localStorage.setItem('showCopyAndPaste', 'false');
        if (kLogging) console.log("Set showCopyAndPaste false.");
    }
}

function EnableCopyPaste() {
    let items = Array.from(elements.copyPaste.getElementsByClassName("copy-paste-item"));

    items.forEach((item) => {
        let copyPasteButton = item.getElementsByClassName("copy-paste-button")[0];
        let removeButton = item.getElementsByClassName("remove-button")[0];

        if (item.pasteValue !== undefined) {
            copyPasteButton.innerText = "Paste";
            removeButton.style.display = "block";
            removeButton.style.visibility = "visible";
        }
        else {
            copyPasteButton.innerText = "Copy";
            removeButton.style.display = "none";
            removeButton.style.visibility = "hidden";
        }
    });
}

function APIKeyChanged(event) {
    if ((event !== undefined) && (event !== null)) {
        event.stopPropagation();
    }

	var apiKey = elements.apiKey.value;
	localStorage.setItem('apiKey', apiKey);
    if (kLogging) console.log("Set apiKey to: \"" + apiKey + "\".");
}

function ThemeChanged(event) {
    if ((event !== undefined) && (event !== null)) {
        event.stopPropagation();
    }

	var theme = elements.theme.value;
	localStorage.setItem("theme", theme);
    if (kLogging) console.log("Set theme to: \"" + theme + "\".");

	UseTheme();
}

function StopWordsSetFocus() {
    elements.stopWords.focus();
    let stopWordsLength = elements.stopWords.value.length;
    elements.stopWords.setSelectionRange(stopWordsLength, stopWordsLength);
}

function Complete() {
    if (!IsCompleting() && !IsReplaying()) {
        PushChange();

        script.statusMode = kStatusMode.evaluating;
        script.completionStartedMS = Date.now();
        script.completionEndedMS = 0;
        script.evaluatingEstimatedMS = 0;
        script.evaluatingTokensProcessed = 0;
        script.evaluatingTokensTotal = 0;
        script.stoppedByWord = "";
        script.stoppedAfterTokens = 0;

        var workAreaText = elements.workAreaText.value;

        var temperature = parseFloat(elements.temperature.value);
        if (kLogging) console.log('temperature: ' + temperature);
    
        var tokens = parseFloat(elements.tokens.value);
        if (kLogging) console.log('tokens: ' + tokens);
    
        var stopWordsText = elements.stopWords.value;
        if (kLogging) console.log('stop words: ' + stopWordsText);
    
        var stopWords = [];
        if (stopWordsText !== "") {
            stopWords = stopWordsText.split(",")
        }

        if (!elements.stopWordsCheckbox.checked) {
            stopWords = [];
        }

		var apiKey = elements.apiKey.value;
        if (kLogging) console.log('API Key: ' + apiKey);

        if (kLogging) console.log(workAreaText);

        if (script.tokenCount <= script.contextWindowSize) {
            SetCompleting(true);
            StartCompleting(workAreaText, temperature, tokens, stopWords);
        }
        else {
            let problemText = "\n\n----------------------------------------\n\n" +
                "The text in the work area (" + script.tokenCount + " tokens) exceeds the context window size (" + script.contextWindowSize + " tokens) for this model.\n\n" +
                "Please remove some text from the work area or switch to a bigger model.\n";
            elements.workAreaText.value = elements.workAreaText.value + problemText;

            script.statusMode = kStatusMode.error;

            ScrollToEnd();
            PushChange();
        }
    }
}

function SetCompleting(value) {
    if (IsCompleting() != value) {
		//	something else should set this if value is false.
        //	script.completing = value;
		if (value) {
			script.statusMode = kStatusMode.completing;
		}
	}

    ShowHideStatusButtons();
    EnableCopyPaste();

	if (IsCompleting()) {
		//  elements.statusStop.focus();
	
		elements.workAreaText.readOnly = true;
		elements.workAreaText.caretColor = "transparent";
		elements.workAreaText.classList.add("working");

		WorkAreaFocus();
	}
	else {
		elements.workAreaText.readOnly = false;
		elements.workAreaText.caretColor = null;
		elements.workAreaText.classList.remove("working");

		WorkAreaFocus();

		PushChange();
    }
}

async function StartCompleting(workAreaText, temperature, tokens, stopWords) {
    let logThis = false;

    // show that we're working??
    script.statusMode = kStatusMode.evaluating;

    var success = true;
    var data = {
        "prompt": workAreaText,
        "echo": true,
        "n_predict": tokens,
        "temperature": temperature,
        "stream": true,
        "return_progress": true,
    }

    if (stopWords.length > 0) {
        data.stop = stopWords;
    }

    var progressText = workAreaText;

    script.completingController = new AbortController();
    script.manualStop = false;
    script.completedContent = '';

    try {
        const response = await fetch(kCompletionsURL, {
            method: 'POST',
            mode: 'cors',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data),
            signal: script.completingController.signal,
        });

        ShowHideStatusButtons();

        let responseDone = false;
        let leftover = ""; // Buffer for partially read lines
        let content = workAreaText;

        const reader = response.body.getReader();
        const decoder = new TextDecoder();  // text encoding.
       
        while (!responseDone) {
    
            const chunk = await reader.read();

            // handle partial results
            const text = leftover + decoder.decode(chunk.value);
            const endsWithLineBreak = text.endsWith('\n');
            let lines = text.split('\n');

            // partial result goes into leftover for next time.
            if (!endsWithLineBreak) {
                leftover = lines.pop();
            }
            else {
                leftover = ""; // Reset leftover if we have a line break at the end
            }

            if (chunk.done) {
                if (kLogging || logThis) console.log("chunk.done");
                responseDone = true;
            }

            // handle each line - data: {whatever}
            for (const line of lines) {
                const regex = /^(\S+):\s(.*)$/gm;
                const match = regex.exec(line);

                let lineData = {};
            
                if (match) {
                    lineData[match[1]] = match[2];        //  data: { whatever }
                    if (kLogging || logThis) console.log(match[1] + ": " + match[2]);
                }

                if (lineData.data) {
                    lineData.data = JSON.parse(lineData.data);

                    if (kLogging || logThis) console.log(lineData.data);

                    if ("prompt_progress" in lineData.data) {
                        if (kLogging || logThis) console.log("Prompt processing:");
                        if (kLogging || logThis) console.log(lineData.data.prompt_progress);

                        let processed = lineData.data.prompt_progress.processed;
                        let total = lineData.data.prompt_progress.total;
						let elapsedMS = Date.now() - script.completionStartedMS;
						let estimatedMS = (processed > 0) ? (elapsedMS * total) / processed : 0;
						if (estimatedMS > 0) {
							// Add 10 seconds
			            	estimatedMS += (10 * 1000);
							// Round up nearest 10 seconds. That's why it's 10000.
			            	estimatedMS = 10000 * Math.ceil(estimatedMS / 10000);
						}

                        script.evaluatingEstimatedMS = estimatedMS;
                        script.evaluatingTokensProcessed = processed;
                        script.evaluatingTokensTotal = total;

                        if (kLogging || logThis) console.log("n_past: " + processed);
                        if (kLogging || logThis) console.log("n_prompt_tokens: " + total);
                        if (kLogging || logThis) console.log("elapsedMS: " + elapsedMS);
                        if (kLogging || logThis) console.log("evaluatingEstimatedMS: " + script.evaluatingEstimatedMS);

                        if (processed < total) {
                            script.statusMode = kStatusMode.evaluating_progress;
                        }
                        else {
                            script.statusMode = kStatusMode.evaluating_finishing;
                        }
                    }
                    else if (lineData.data.stop) {
                        if (lineData.data.stop_type == "word") {
                            script.statusMode = kStatusMode.stopped_by_word;
                            script.stoppedByWord = lineData.data.stopping_word;
                
                            content = content + lineData.data.stopping_word;
                            script.completedContent = script.completedContent + lineData.data.stopping_word;
                            elements.workAreaText.value = content;

                            WorkAreaFocus();
                            ScrollToEnd();
                            
                            script.completingController = null;
                            ShowHideStatusButtons();
                        }
                        else if (lineData.data.stop_type == "limit") {
                           script.statusMode = kStatusMode.stopped_after;
                           script.stoppedAfterTokens = lineData.data.tokens_predicted;
                            
                            content = content + lineData.data.content;
                            script.completedContent = script.completedContent + lineData.data.content;
                            elements.workAreaText.value = content;
                            
                            ScrollToEnd();

                            script.completingController = null;
                            ShowHideStatusButtons();
                        }
                        else if (lineData.data.stop_type == "eos") {
                            script.completionEndedMS = Date.now();
                            script.statusMode = kStatusMode.completed;

                            content = content + lineData.data.content;
                            script.completedContent = script.completedContent + lineData.data.content;
                            elements.workAreaText.value = content;

                            ScrollToEnd();

                            if (kLogging || logThis) console.log("end of stream");
                            script.completingController = null;
                            ShowHideStatusButtons();
                        }
                    }

                    else if (lineData.data.content !== undefined) {
                        script.statusMode = kStatusMode.completing;

                        content = content + lineData.data.content;
                        script.completedContent = script.completedContent + lineData.data.content;
                        elements.workAreaText.value = content;

                        ScrollToEnd();
                    }

                }
            }
        }
    }
    catch(exc) {
        if (kLogging || logThis) console.log("Exception caught receiving results.");
        if (kLogging || logThis) console.log(exc.name);
        if (kLogging || logThis) console.log(exc.message);

        if (!script.manualStop) {
            script.statusMode = kStatusMode.error;
        }

        // I thought this might be a checkbox in settings, but that felt clumsy.
        // These are mostly network errors. It would be good for the user to know.
        // -Brad 2025-07-25
        let reportProblemsInWorkArea = true;
        if (reportProblemsInWorkArea) {
            if (!exc.name.includes("AbortError")) {
                let problemText = "\n\n----------------------------------------\n\n" +
                    "A problem was encountered while completing:\n\n" +
                    exc + "\n\n";
                elements.workAreaText.value = elements.workAreaText.value + problemText;

                setTimeout(function() {
                    ScrollToEnd();
                }, 100);
            }
        }
    }

    script.completingController = null;
    SetCompleting(false);
}

function StopCompleting() {
    if (script.completingController !== null) {
        script.completingController.abort();
        script.completingController = null;
        script.manualStop = true;

        script.statusMode = kStatusMode.stopped_by_user;
        SetCompleting(false);
		UpdateStatus();
        ShowHideStatusButtons();
		PushChange();

        WorkAreaFocus();
        ScrollToEnd();
    }
}

function Replay() {
    if (!IsCompleting() && !IsReplaying()) {
        PushChange();

        SetReplaying(true);
        script.statusMode = kStatusMode.replaying;
 
        var workAreaText = elements.workAreaText.value;
        var words = script.replayText.split(' ');
        var i = 0;

        function type() {
            if (IsReplaying() && (i < words.length)) {
                var newText = '';
                if (i > 0) {
                    newText = ' ';
                }
                newText = newText + words[i];
                elements.workAreaText.value += newText;
                ScrollToEnd();
                i++;
                setTimeout(type, kReplayDelay);
            }
            else {
                elements.workAreaText.value = workAreaText + script.replayText;
                ScrollToEnd();

                SetReplaying(false);
                script.completedContent = script.replayText;
				script.replayText = "";
            }
        }
        
        type();
    }
}

function SetReplaying(value) {
    if (IsReplaying() != value) {
        //	script.replaying = value;
		if (value) {
            script.statusMode = kStatusMode.replaying;
		}
		else {
			script.statusMode = kStatusMode.editing;
			PushChange();
		}
	}
	
	ShowHideStatusButtons();

	if (IsReplaying()) {
		//  elements.statusStop.focus();
	
		elements.workAreaText.classList.add("working");
		WorkAreaFocus();
	}
	else {
		elements.workAreaText.classList.remove("working");
		WorkAreaFocus();
    }
}

function StopReplaying() {
    SetReplaying(false);
}

function WorkAreaTextPaste() {
    if (!IsCompleting() && !IsReplaying()) {
        // Force this to happen after the paste. If you double paste
        // too quickly, it will get caught in the same change.
        setTimeout(() => {
            PushChange();
        }, 500);
    }
    else {
        event.preventDefault(); // Prevent the default paste behavior
    }

    script.statusMode = kStatusMode.editing;
    ShowHideStatusButtons();
}

function ShowHideStatusButtons() {
    if ((elements.workAreaText.value != '') && !IsCompleting() && !IsReplaying()) {
        ShowElement(elements.statusStart);
    }
    else {
        HideElement(elements.statusStart);
    }

    if (IsCompleting() || IsReplaying()) {
        ShowElement(elements.statusStop);
    }
    else {
        HideElement(elements.statusStop);
    }

    if ((script.isMobile || true) && (elements.workAreaText.value != '') && (undoStack.length > 0) && !IsCompleting() && !IsReplaying()) {
        ShowElement(elements.statusUndo);
    }
    else {
        HideElement(elements.statusUndo);
    }

    if ((script.isMobile || true) && (elements.workAreaText.value != '') && !IsCompleting() && !IsReplaying()) {
        ShowElement(elements.statusClear);
    }
    else {
        HideElement(elements.statusClear);
    }
}

function UpdateStatus() {
    let logThis = false;
    let status = "<b>Status</b>: ";

    //  elements.status.innerHTML = status;

    if (kLogging || logThis) console.log("UpdateStatus: " + script.statusMode);

    if (script.statusMode == kStatusMode.preparing) {
        status += kStatusText.preparing;
    }
    else if (script.statusMode == kStatusMode.editing) {
        let workAreaLength = elements.workAreaText.value.length;
		if (workAreaLength == 0) {
            status += kStatusText.editing_empty;
		}
		else {
            status += kStatusText.editing_ready_to_complete;
		}
        var w = elements.content.offsetWidth;
        if (w >= 400) {
            if (script.contextWindowSize > 0) {
                status += " <b>Tokens:</b> " + script.tokenCount + " / " + script.contextWindowSize + ".";
            }
            else if (script.tokenCount > 0) {
                status += " <b>Tokens:</b> " + script.tokenCount + ".";
            }
        }
    }
    else if (script.statusMode == kStatusMode.evaluating) {
        status += kStatusText.evaluating;

        let elapsedMS = Date.now() - script.completionStartedMS;
        if (elapsedMS > 0) {
            status += " <b>Time:</b> " + GetElapsedTimeString(elapsedMS) + ".";
        }
    }
    else if (script.statusMode == kStatusMode.evaluating_progress) {
        status += kStatusText.evaluating_progress;

        if (kLogging || logThis) console.log("evaluating_progress");
        if (kLogging || logThis) console.log("- evaluatingTokensProcessed: " + script.evaluatingTokensProcessed);
        if (kLogging || logThis) console.log("- evaluatingTokensTotal: " + script.evaluatingTokensTotal);
        if (kLogging || logThis) console.log("- evaluatingEstimatedMS: " + script.evaluatingEstimatedMS);

        if (script.evaluatingTokensTotal > 0) {
            status = status + script.evaluatingTokensProcessed + " / " + script.evaluatingTokensTotal + ".";
        }
        else {
            status = status.trimEnd() + ".";
        }

        let elapsedMS = Date.now() - script.completionStartedMS;
        if (elapsedMS > 0) {
            status += " <b>Time:</b> " + GetElapsedTimeString(elapsedMS);

            if (script.evaluatingEstimatedMS > 0) {
                status += " / " + GetElapsedTimeString(script.evaluatingEstimatedMS);
            }

            status += ".";
        }
    }
    else if (script.statusMode == kStatusMode.evaluating_finishing) {
        status += kStatusText.evaluating_finishing;

        let elapsedMS = Date.now() - script.completionStartedMS;
        if (elapsedMS > 0) {
            status += " <b>Time:</b> " + GetElapsedTimeString(elapsedMS) + ".";
        }
    }
    else if (script.statusMode == kStatusMode.completing) {
        status += kStatusText.completing;

        let elapsedMS = Date.now() - script.completionStartedMS;
        if (elapsedMS > 0) {
            status += " <b>Time:</b> " + GetElapsedTimeString(elapsedMS) + ".";
        }
    }
    else if (script.statusMode == kStatusMode.completed) {
        status += kStatusText.completed;

        if (script.completionEndedMS > 0) {
            let elapsedMS = script.completionEndedMS - script.completionStartedMS;
            let elapsedTime = GetElapsedTimeString(elapsedMS);
            status = status.replace('[elapsed_time]', elapsedTime);
        }
        else {
            status = status.replace(' in [elapsed_time]', "");
        }
    }
    else if (script.statusMode == kStatusMode.stopped_by_word) {
        status += kStatusText.stopped_by_word;

        if (script.stoppedByWord != "") {
            status = status.replace('[word]', script.stoppedByWord);
        }
        else {
            status = status.replace('\"[word]\"', 'word.');
        }
    }
    else if (script.statusMode == kStatusMode.stopped_after) {
        status += kStatusText.stopped_after;

        status = status.replace('[tokens_predicted]', script.stoppedAfterTokens);
        if (script.stoppedAfterTokens == 1) {
            status = status.replace('tokens', 'token');
        }
    }
    else if (script.statusMode == kStatusMode.stopped_by_user) {
        status += kStatusText.stopped_by_user;
    }
    else if (script.statusMode == kStatusMode.ready_to_replay) {
        status += kStatusText.ready_to_replay;
    }
    else if (script.statusMode == kStatusMode.replaying) {
        status += kStatusText.replaying;
    }
    else if (script.statusMode == kStatusMode.error) {
        status += kStatusText.error;
    }

    elements.statusText.innerHTML = status;
}

function WorkAreaTextKeyDown(event) {
    let logThis = false;
    if (kLogging || logThis) console.log('WorkAreaTextKeyDown()');
    
    // if we're completing, return true
    if (IsCompleting()) {
        if (kLogging || logThis) console.log('- completing');
        event.preventDefault();

        // return key in the field should stop completing.
        if (event.keyCode == 13) {
            if ((Date.now() - script.completionStartedMS) >= kCompletionMinimumTimeMS) {
                if (kLogging || logThis) console.log('- return');
                StopCompleting();
            }
        }
    }

    else if (IsReplaying()) {
        if (kLogging || logThis) console.log('- replaying');
        event.preventDefault();

        // return key in the field should stop replaying.
        if (event.keyCode == 13) {
            if (kLogging || logThis) console.log('- return');
            StopReplaying();
        }
    }

    // if we're not completing or replaying, and we get a return key, kick off completing.
    else if ((event.keyCode == 13) && event.shiftKey) {
        if (kLogging || logThis) console.log("Enter key was pressed.");

        if (event.ctrlKey) {
            elements.workAreaText.value = elements.workAreaText.value + '\n';
            let workAreaLength = elements.workAreaText.value.length;
            elements.workAreaText.setSelectionRange(workAreaLength, workAreaLength);
        }
        event.preventDefault();

        setTimeout(() => {
			if (script.replayText !== "") {
				Replay();
			}
			else {
            	Complete();
			}
        }, 500);
    }

    // home
    else if ((event.keyCode == 36)) {
        elements.workAreaText.scrollTop = 0;
        elements.workAreaText.setSelectionRange(0, 0);
    }

    // end
    else if ((event.keyCode == 35)) {
        ScrollToEnd();
        let workAreaLength = elements.workAreaText.value.length;
        elements.workAreaText.setSelectionRange(workAreaLength, workAreaLength);
    }

    else if (!event.ctrlKey) {
        // This will change the content area, so forget completedContent.
        script.completedContent = "";
		script.replayText = "";
        script.statusMode = kStatusMode.editing;
        EnableCopyPaste();
    }

	UpdateStatus();
    ShowHideStatusButtons();
}

function WorkAreaTextClicked(event) {
    var result = false;

    // CTRL key works great on Windows and Linux, but is context menu combination on Mac.
    // OPTION key works great on Mac, but isn't as easy to reach as CTRL key on Windows and Linux.
    // So allow both.
    if (event.altKey || event.ctrlKey) {
        if (kLogging) console.log("CTRL-LEFT");

        var selectionStart = elements.workAreaText.selectionStart;

        var text = elements.workAreaText.value;
        if (selectionStart > 0) {
            text = text.substring(0, selectionStart);
            elements.workAreaText.value = text;
        }
        result = true;
    }

    return result;
}

function WorkAreaFocus() {
    elements.workAreaText.focus();
}

function FullscreenChange() {
    if (document.fullscreenElement) {
        elements.fullscreenIcon.classList.add("hidden");
        elements.restoreIcon.classList.remove("hidden");
    }
    else {
        elements.fullscreenIcon.classList.remove("hidden");
        elements.restoreIcon.classList.add("hidden");
    }
}

function KeyPress(event) {
    var evtobj = window.event? event : e

    if (event.ctrlKey && !event.shiftKey && (event.key == 'z')) {
        if (kLogging) console.log('ctrl-z');
        event.preventDefault();

        UndoChange();
    }

    if (event.ctrlKey && event.shiftKey && (event.key == 'Z')) {
        if (kLogging) console.log('ctrl-shift-Z');
        event.preventDefault();

        RedoChange();
    }

    if (event.ctrlKey && !event.shiftKey && (event.key == 'b')) {
        if (kLogging) console.log('ctrl-b');
        event.preventDefault();

		// bookmark panel needs a close button to just show work area.
		// ShowPanel(event, "bookmark");
		IconClickedBookmark(event);
    }

    if (event.ctrlKey && !event.shiftKey && (event.key == 'e')) {
        if (kLogging) console.log('ctrl-e');
        event.preventDefault();

		ShowPanel(event, "settings");
    }

    if (event.ctrlKey && !event.shiftKey && (event.key == 'l')) {
        if (kLogging) console.log('ctrl-l');
        event.preventDefault();

		ShowPanel(event, "tools");
    }
}

undoStack = new Array();
redoStack = new Array();

function PushChange() {
	var logThis = false;
	if (logThis) console.log("PushChange()");
	if (logThis) console.log("- undoStack.length: " + undoStack.length);
	if (logThis) console.log("- redoStack.length: " + redoStack.length);
	
    var changed = false;

    if (undoStack.length == 0) {
        changed = true;
    }
    else if (undoStack.length > 0) {
        item = undoStack.at(-1)  // top of stack

        if (item.workAreaText != elements.workAreaText.value) {
            changed = true;
        }
    }

    if (changed) {
        if (logThis) console.log("- Pushing change.");
        if (logThis) console.log("- " + elements.workAreaText.value.length);
        item = {
            workAreaText:       elements.workAreaText.value,
            selectionStart:     elements.workAreaText.selectionStart,
            selectionEnd:       elements.workAreaText.selectionEnd,
            completedContent:   script.completedContent,
        }
        undoStack.push(item);
        redoStack.length = 0;
        if (logThis) LogUndoRedoStacks();
    }

    EnableCopyPaste();
}

function UndoChange() {
	var logThis = false;
	if (logThis) console.log("UndoChange()");
	if (logThis) console.log("- undoStack.length: " + undoStack.length);
	
    // text has changed since last command. Create an item and push it onto redoSack.
    if (undoStack.length > 0) {
        if (logThis) console.log("- Undoing change.");
        item = undoStack.at(-1);   // top of stack

        if (elements.workAreaText.value != item.workAreaText) {
            if (kLogging) console.log("Pushing most recent change.");
            PushChange();
            item = undoStack.pop();
            redoStack.push(item);
        }

        if (logThis) console.log("- Popping item from undoStack, pushing to redoStack.");
        item = undoStack.pop();
        redoStack.push(item);

        if (logThis) console.log("- Setting workAreaText to top of undoStack.");
        if (undoStack.length > 0) {
            item = undoStack.at(-1);
            elements.workAreaText.value             = item.workAreaText;
            elements.workAreaText.selectionStart    = item.selectionStart;
            elements.workAreaText.selectionEnd      = item.selectionEnd;
            script.completedContent                 = item.completedContent;
        }
        else {
            elements.workAreaText.value = "";
            elements.workAreaText.selectionStart = 0;
            elements.workAreaText.selectionEnd = 0;
            script.completedContent = "";
        }

        if (kLogging) console.log(elements.workAreaText.value.length);
        if (kLogging) LogUndoRedoStacks();
    }

    EnableCopyPaste();
    ShowHideStatusButtons();
}

function RedoChange() {
	var logThis = false;
	if (logThis) console.log("RedoChange()");
	if (logThis) console.log("- redoStack.length: " + redoStack.length);

	if (redoStack.length > 0) {
        if (logThis) console.log("- Redoing change.");

        if (logThis) console.log("- Popping item from redoStack, pushing to undoStack.");
        item = redoStack.pop();
        undoStack.push(item);

        if (logThis) console.log("- Setting workAreaText to top of undoStack.");
        elements.workAreaText.value             = item.workAreaText;
        elements.workAreaText.selectionStart    = item.selectionStart;
        elements.workAreaText.selectionEnd      = item.selectionEnd;
        script.completedContent                 = item.completedContent;

        if (logThis) console.log("- " + elements.workAreaText.value.length);
        if (logThis) LogUndoRedoStacks();
    }

    EnableCopyPaste();
}

function LogUndoRedoStacks() {
    if (kLogging) {
        console.log("- undoStack.length: " + undoStack.length);
        for (var i = 0; i < undoStack.length; i++) {
            item = undoStack[i];
            console.log("  - [" + i + "]: " + item.workAreaText.length);
        }
        console.log("- redoStack.length: " + redoStack.length);
        for (var i = 0; i < redoStack.length; i++) {
            item = redoStack[i];
            console.log("  - [" + i + "]: " + item.workAreaText.length);
        }
    }
}

function ClearUndoRedoStack() {
    undoStack = new Array();
    redoStack = new Array();
}

function ShowAbout() {
    // Future: About box overlay.
    // Move the copyright message and the LLM Club links in there.
}

function LoadPrint() {
    let printSize = elements.printSize.value;
    let pictureWidth = elements.pictureWidth.value;
    let pictureUrl = elements.pictureUrl.value.trim();
    let printText = elements.workAreaText.value;

    if (pictureUrl != '') {
        elements.printPicture.src = pictureUrl;
        elements.printPicture.style.width = pictureWidth;
        ShowElement(elements.printPicture);
    }
    else {
        HideElement(elements.printPicture);
    }

    if (printText == '') {
        printText = elements.workAreaText.placeholder;
        printText = printText.replaceAll('    ', '&nbsp;&nbsp;&nbsp;&nbsp;');
    } 

    printText = printText.replace(/\r\n/g, '<br/>');
    printText = printText.replace(/\r/g, '<br/>');
    printText = printText.replace(/\n/g, '<br/>');

    elements.printContent.innerHTML = printText;
    elements.printContent.style.fontSize = printSize;
}

async function GetModelInfoFromServer() {
    var success = true;

    const response = await fetch(kModelsURL, {
        method: 'GET',
        mode: 'cors',
        headers: {
            'Content-Type': 'application/json',
        },
        // body: JSON.stringify(data),
        // signal: script.completingController.signal,
    });

    const json = await response.json();

    try {
        if (kLogging) console.log("json:\n");
        if (kLogging) console.log(json);

        const data0 = json.data[0];
        script.metadata = data0.meta;
        script.modelName = script.metadata["general.name"];
        const n_ctx_train = script.metadata["n_ctx_train"];
        const n_ctx = script.metadata["n_ctx"];

        if (kLogging) console.log("json.data[0]:\n");
        if (kLogging) console.log(data0);

        if (kLogging) console.log("json.data[0].meta:\n");
        if (kLogging) console.log(script.metadata);

        if (kLogging) console.log("meta[\"general.name\"]:\n");
        if (kLogging) console.log(script.modelName);

        if (kLogging) console.log("meta[\"n_ctx_train\"]:\n");
        if (kLogging) console.log(n_ctx_train);

        script.contextWindowSize = n_ctx;
        elements.model.innerHTML = script.modelName;
    }
    catch(exc) {
        if (kLogging) console.log("Exception caught receiving results from " + kModelsURL + ".");
        if (kLogging) console.log(exc);

        script.modelName = "";
        elements.model.innerHTML = '';
    }
}

function ShowPanel(event, panel) {
    event.stopPropagation();

	if ((panel === undefined) || (panel === null) || (panel === "")) {
		panel = "work-area";
	}

	// Hide all panels
	if (!elements.filesArea.classList.contains("hidden") && (panel != "files")) {
    	HideElement(elements.filesArea);
	}
	if (!elements.bookmarkMaker.classList.contains("hidden") && (panel != "bookmark")) {
    	HideElement(elements.bookmarkMaker);
	}
	if (!elements.helpContainer.classList.contains("hidden") && (panel != "help")) {
    	HideElement(elements.helpContainer);
	}
	if (!elements.workArea.classList.contains("hidden") && ((panel == "files") || (panel == "bookmark") || (panel == "help"))) {
    	HideElement(elements.workArea);
    	HideElement(elements.status);
	}
	if (!elements.settings.classList.contains("hidden") && (panel != "settings")) {
		HideElement(elements.settings);
	}
	if (!elements.tools.classList.contains("hidden") && (panel != "tools") && (panel != "print") && (panel != "bookmark")) {
    	HideElement(elements.tools);
	}
	if (!elements.print.classList.contains("hidden") && (panel != "print")) {
    	HideElement(elements.print);
	}
	
	// Show the right panels
	if (elements.filesArea.classList.contains("hidden") && (panel == "files")) {
		ShowFilesDirectoryName();
		PopulateFilesList();
		ShowSelectedFile();
    	ShowElement(elements.filesArea);
	}
	if (elements.bookmarkMaker.classList.contains("hidden") && (panel == "bookmark")) {
		let hash = MakeHash();
		UseBookmarkHash(hash);
    	ShowElement(elements.bookmarkMaker);
	}
	if (elements.helpContainer.classList.contains("hidden") && (panel == "help")) {
    	ShowElement(elements.helpContainer);
	}
	if (elements.workArea.classList.contains("hidden") && ((panel != "files") && (panel != "bookmark") && (panel != "help"))) {
    	ShowElement(elements.workArea);
    	ShowElement(elements.status);
		WorkAreaFocus();
	}
	if (elements.settings.classList.contains("hidden") && (panel == "settings")) {
		ShowElement(elements.settings);
	}
	if (elements.tools.classList.contains("hidden") && ((panel == "tools") || (panel == "print") || (panel == "bookmark"))) {
    	ShowElement(elements.tools);
	}
	if (elements.print.classList.contains("hidden") && (panel == "print")) {
    	ShowElement(elements.print);
	}
}

function IconClickedSettings(event) {
	if (event.shiftKey) {
		NextTheme();
    	event.stopPropagation();
	}
	else {
		if (elements.settings.classList.contains("hidden")) {
			ShowPanel(event, "settings");
		}
		else {
			ShowPanel(event, "work-area");
		}
	}
}

function IconClickedTools(event) {
	if (elements.tools.classList.contains("hidden")) {
		ShowPanel(event, "tools");
	}
	else {
		ShowPanel(event, "work-area");
	}
}

function IconClickedFiles(event) {
	if (elements.filesArea.classList.contains("hidden")) {
		ShowPanel(event, "files");
	}
	else {
		ShowPanel(event, "work-area");
	}
}

function IconClickedHelp(event) {
	if (elements.helpContainer.classList.contains("hidden")) {
		ShowPanel(event, "help");
	}
	else {
		ShowPanel(event, "work-area");
	}
}

function IconClickedPrint(event) {
	if (elements.print.classList.contains("hidden")) {
		ShowPanel(event, "print");
	}
	else {
		ShowPanel(event, "tools");
	}
}

function IconClickedBookmark(event) {
	if (elements.bookmarkMaker.classList.contains("hidden")) {
		ShowPanel(event, "bookmark");
	}
	else {
		ShowPanel(event, "tools");
	}
}

function IconClickedFullScreen(event) {
    event.stopPropagation();

    if (!document.fullscreenElement) {
        document.documentElement.requestFullscreen();
	}
}

function IconClickedRestore(event) {
    event.stopPropagation();

    if (document.fullscreenElement) {
        if (kLogging) ('Exit fullscreen.');
        document.exitFullscreen();
    }
}

function ToggleFiles_Old(event) {
    event.stopPropagation();
	if (!elements.bookmarkMaker.classList.contains("hidden")) {
		ToggleBookmarkMaker_Old(event);
	}

	if (elements.filesArea.classList.contains("hidden")) {
		ShowFilesDirectoryName();
		
		PopulateFilesList();
		ShowSelectedFile();
    	HideElement(elements.workArea);
    	HideElement(elements.status);

		/*
		if (script.hasDirectoryPicker) {
			ShowElement(elements.filesAreaHeader);
		}
		else {
			HideElement(elements.filesAreaHeader);
		}
		*/
    	ShowElement(elements.filesArea);
	}
	else {
    	HideElement(elements.filesArea);
    	ShowElement(elements.workArea);
    	ShowElement(elements.status);
		WorkAreaFocus();
	}

    HideElement(elements.helpContainer);
	HideElement(elements.settings);
    HideElement(elements.tools);
    HideElement(elements.print);
    HideElement(elements.helpContainer);
}

function ToggleBookmarkMaker_Old(event) {
    event.stopPropagation();
	if (!elements.filesArea.classList.contains("hidden")) {
		ToggleFiles_Old(event);
	}

	HideElement(elements.settings);
    HideElement(elements.print);
    HideElement(elements.helpContainer);
    ShowElement(elements.tools);

	if (elements.bookmarkMaker.classList.contains("hidden")) {
		let hash = MakeHash();
		UseBookmarkHash(hash);
		
    	HideElement(elements.workArea);
    	HideElement(elements.status);
    	ShowElement(elements.bookmarkMaker);
	}
	else {
    	HideElement(elements.bookmarkMaker);
		ShowElement(elements.workArea);
    	ShowElement(elements.status);
		WorkAreaFocus();
	}
}

function ScrollToEnd() {
    if (elements.workAreaText.value != '') {
        elements.workAreaText.scrollTop = elements.workAreaText.scrollHeight;
    }
    else {
        elements.workAreaText.scrollTop = 0;
    }
    let workAreaTexLength = elements.workAreaText.value.length;
    elements.workAreaText.setSelectionRange(workAreaTexLength, workAreaTexLength);
}

function ScrollToSelectionStart() {
	// Help from Google Gemini on this. Allegedly no-flicker.
	// https://share.google/aimode/AvqJraXA5OSjvJwbq

	WorkAreaFocus();
	
	const originalText = elements.workAreaText.value;
	const selectionStart = elements.workAreaText.selectionStart;
	const selectionEnd = elements.workAreaText.selectionEnd;
	
	// Slice the text exactly where the selection begins
	elements.workAreaText.value = originalText.substring(0, selectionStart);
	
	// Force the textarea to scroll to the very bottom of this sliced text
	elements.workAreaText.scrollTop = elements.workAreaText.scrollHeight;
	
	// Restore original text and re-apply selection bounds seamlessly
	elements.workAreaText.value = originalText;
	elements.workAreaText.setSelectionRange(selectionStart, selectionEnd);
}

function MakeHash() {
    let logThis = false;
    if (kLogging || logThis) console.log("MakeHash(" + completed + ")");
    if (kLogging || logThis) console.trace();

    let result = '';

    if (script.completedContent === undefined) {
        script.completedContent = '';
    }
	if (kLogging || logThis) console.log("- script.completedContent: " + script.completedContent);

    var workAreaText = elements.workAreaText.value;
    var cue = '';
    var completed = '';

    if ((script.completedContent != '') && (workAreaText.endsWith(script.completedContent))) {
		if (kLogging || logThis) console.log("- Have cue and completed.");
        cue = workAreaText.substring(0, workAreaText.length - script.completedContent.length);
        completed = script.completedContent;
    }
    else {
		if (kLogging || logThis) console.log("- Have cue.");
        cue = workAreaText;
        completed = "";
    }

    let temperature = "";
    let tokens = "";
    let stopWordsText = "";

    if (completed == "") {
        temperature = elements.temperature.value;
        tokens = elements.tokens.value;
        stopWordsText = elements.stopWords.value;
        if (!elements.stopWordsCheckbox.checked) {
            stopWordsText = '';
        }
    }
    let mode = kModeCueLink;
    let autoComplete = false;

    var label = 'Mmojo Complete';
    if (cue != '') {
        label = (completed != '') ? "Completed: " : "Complete: ";
    }
    label = label + workAreaText.split(' ').slice(0,10).join(' ');

    var data = {
        "label": label,
        "temperature": temperature,
        "tokens": tokens,
        "stop-words": stopWordsText,
        "mode": mode,
        "auto-complete": autoComplete,
        "cue": cue,
        "completed": completed,
    }

    var dataJson = JSON.stringify(data);
    if (kLogging || logThis) console.log("- dataJson: " + dataJson);

    var hash = "";
    try {
        hash = '#' + btoa(encodeURIComponent(dataJson));
    }
    catch {
        hash = "";
    }
    if (kLogging || logThis) console.log("- hash: " + hash);

    result = hash;
    return result;
}

function HashChange() {
    let logThis = false;
    if (kLogging || logThis) console.log("HashChange()");
    if (kLogging || logThis) console.log("- location.hash:" + location.hash);

    if (location.hash != "") {
        UseHash();
    }
}

function UseHash() {
    let logThis = false;
    if (kLogging || logThis) console.log("UseHash()");
 
    if (script.completingController !== null) {
        StopCompleting();
    }

    let label = null;
    let temperature = null;
    let tokens = null;
    let stopWords = null;
    let mode = kModeCueLink;
    let autoComplete = false;
    let cue = "";
    let completed = "";

    // If something goes wrong, restore the settings.
    let saveWorkAreaValue = elements.workAreaText.value;
    let saveTemperatureValue = elements.temperature.value;
    let saveTokensValue = elements.tokens.value;
    let saveStopWordsCheckboxValue = elements.stopWordsCheckbox.checked;
    let saveStopWordsValue = elements.stopWords.value;

    try {
        var dataJson = decodeURIComponent(atob(location.hash.replace('#', '')));

        if (dataJson != '') {
            if (kLogging || logThis) console.log("dataJson:");
            if (kLogging || logThis) console.log(dataJson);
            var data = JSON.parse(dataJson);
            if (kLogging || logThis) console.log("data:");
            if (kLogging || logThis) console.log(data);

            // content will be pasted in immediately.
            // completed will be pasted in by replayer.

            if ('temperature' in data) {
                temperature = data['temperature'];
            }
            if ('tokens' in data) {
                tokens = data['tokens'];
            }
            if ('stop-words' in data) {
                stopWords = data['stop-words'];
            }
            if ('auto-complete' in data) {
                autoComplete = data['auto-complete'];
            }
            if ('mode' in data) {
                mode = data['mode'];
            }
            if ('append' in data) {
                let append = data['append'];
                if (append) {
                    mode = kModeAppend;
                }
            }
            if ('replace' in data) {
                let replace = data['replace'];
                if (replace) {
                    mode = kModeReplace;
                }
            }
            if ('cue' in data) {
                cue = data['cue'];
            }
            if ('completed' in data) {
                completed = data['completed'];
            }

            // convert old generate to complete.
            if ('generated' in data) {
                completed = data['generated'];
            }

            if ('auto-generate' in data) {
                autoComplete = data['auto-generate'];
            }

            if (kLogging || logThis) console.log('- cue:');
            if (kLogging || logThis) console.log(cue);
            if (kLogging || logThis) console.log('- completed:');
            if (kLogging || logThis) console.log(completed);
        }

        if (mode == kModeAppend) {
            let saveWorkAreaLength = elements.workAreaText.value.length;
            if (kLogging || logThis) console.log("saveWorkAreaLength: " + saveWorkAreaLength);
            elements.workAreaText.value = elements.workAreaText.value + cue;

            let workAreaLength = elements.workAreaText.value.length;
            if (kLogging || logThis) console.log("workAreaLength: " + workAreaLength);

            setTimeout(() => {
                ScrollToEnd();
                if (kLogging || logThis) console.log("Moving cursor.");
                // elements.workAreaText.setSelectionRange(saveWorkAreaLength, saveWorkAreaLength);
                elements.workAreaText.setSelectionRange(workAreaLength, workAreaLength);
            }, 100);

            PushChange();
        }
        else if (mode == kModePrepend) {
            elements.workAreaText.value = cue + elements.workAreaText.value;

            setTimeout(() => {
                elements.workAreaText.scrollTop = 0;
                elements.workAreaText.setSelectionRange(0, 0);
            }, 100);

            PushChange();
        }
		else if (mode == kModePaste) {
            // Update contents of elements.workAreaText.value. Replace selection with cue.
            if (cue != "") {
				elements.workAreaText.setRangeText(cue); 
                completed = "";
                autoComplete = false;
                PushChange();
			}
		}
        else if (mode == kModeReplace) {
            // Update contents of elements.workAreaText.value. Replace cue with completed.
            let text = elements.workAreaText.value;
            if (cue != "") {
                text = text.replaceAll(cue, completed);
                elements.workAreaText.value = text;
                completed = "";
                autoComplete = false;
                PushChange();
            }
        }
        else if (mode == kModeReplaceRegEx) {
            // Update contents of elements.workAreaText.value. Replace cue with completed.
            let text = elements.workAreaText.value;
            if (cue != "") {
                try {
                    let regex = new RegExp(cue, "gi");
                    text = text.replace(regex, completed);
                    elements.workAreaText.value = text;
                    completed = "";
                    autoComplete = false;
                    PushChange();
                }
                catch (error) {
                    if (kLogging || logThis) console.log('kModeReplaceRegEx error:' + error);
                }
            }
        }
        else {
            if (kLogging || logThis) console.log('Mode is cue.');
            elements.workAreaText.value = cue;
            PushChange();
        }

        if ((temperature != null) && (temperature != "")) {
            elements.temperature.value = temperature;
        }
        if ((tokens != null) && (tokens != "")) {
            elements.tokens.value = tokens;
        }

        // they will be forced on or off. not sure this is
        if ((stopWords != null)) {
            elements.stopWordsCheckbox.checked = (stopWords != "");
            elements.stopWords.value = stopWords;
        }

    }
    catch {
        if (kLogging || logThis) console.log('completed != empty.');

        // If something goes wrong, restore the settings.
        elements.workAreaText.value = saveWorkAreaValue;
        elements.temperature.value = saveTemperatureValue;
        elements.tokens.value = saveTokensValue;
        elements.stopWordsCheckbox.checked = saveStopWordsCheckboxValue;
        elements.stopWords.value = saveStopWordsValue;

        cue = null;
        completed = null;
        autoComplete = false;
    }

    elements.workAreaText.disabled = false;
    WorkAreaFocus();
    ScrollToEnd();

	script.replayText = "";
    if ((completed == '') && (elements.workAreaText.value != '') && autoComplete) {
        setTimeout(() => {
            Complete();
        }, kWaitToComplete);
    }
    else if ((completed != null) && (completed != '')) {
		script.statusMode = kStatusMode.ready_to_replay;
		script.replayText = completed;
		UpdateStatus();
		
		if (autoComplete) {
	        setTimeout(() => {
	            Replay();
	        }, kWaitToComplete);
		}
    }

    // show or hide stop words.
    EnableControls();

    location.hash = "";
}

async function CountTokens() {
    kLogThis = false;
    if (kLogging || kLogThis) console.log("CountTokens()");

    var success = true;
    var workAreaText = elements.workAreaText.value;
    var tokensHTML = "";

    if ((script.lastTokenCountText != workAreaText) || (script.lastContentWindowSize != script.contextWindowSize)) {
        script.lastTokenCountText = workAreaText;
        script.lastContentWindowSize = script.contextWindowSize;

        if (kLogging || kLogThis) console.log("POST: " + kTokenizeURL);

        var data = {
            "content": workAreaText,
            "add_special": true,
            "with_pieces": false,
        }
    
        try {

            const response = await fetch(kTokenizeURL, {
                method: 'POST',
                mode: 'cors',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(data),
                // signal: script.completingController.signal,
            });
        
            const json = await response.json();

            if (kLogging || kLogThis) console.log("json:\n");
            if (kLogging || kLogThis) console.log(json);

            const tokens = json.tokens;
            if (kLogging || kLogThis) console.log("tokens:\n");
            if (kLogging || kLogThis) console.log(tokens);

            if (Array.isArray(tokens)) {
                script.tokenCount = tokens.length;

                if (kLogging || kLogThis) console.log("tokens is an array with " + script.tokenCount + " items.");

                if (script.contextWindowSize > 1 ) {
                    tokensHTML = "<b>Tokens:</b> " + script.tokenCount + "&nbsp;/&nbsp;" + script.contextWindowSize;
                }
                else {
                    tokensHTML = "<b>Tokens:</b> " + script.tokenCount;
                }
            }    
        }
        catch(exc) {
            if (kLogging || kLogThis) console.log("Exception caught receiving results from " + kTokenizeURL + ".");
            if (kLogging || kLogThis) console.log(exc.name);
            if (kLogging || kLogThis) console.log(exc.message);

            // As far as the user sees, a silent fail here is OK.
        }

        // elements.statusTokens.innerHTML = tokensHTML;
        ShowHideStatusButtons();
    }

    setTimeout(function() {
        CountTokens();
    }, 2000);
}

function UpdatePicture() {

}

function Chat(event) {
    event.stopPropagation();
    WorkAreaFocus();

    window.open('chat.html', '_blank');
}

function Read(event) {
    event.stopPropagation();
    WorkAreaFocus();

    if (window.speechSynthesis.speaking) {
        window.speechSynthesis.cancel();
    }
    else {
        var textToSpeak = elements.workAreaText.value;
        if (typeof elements.workAreaText.selectionStart !== 'undefined') {
            // Get the start and end positions of the selection
            var startPosition = elements.workAreaText.selectionStart;
            var endPosition = elements.workAreaText.selectionEnd;

            // console.log("startPosition: " + startPosition);
            // console.log("endPosition: " + endPosition);

            // Use the substring method on the textarea's value to get the selected text
            if (startPosition < endPosition) {
                textToSpeak = elements.workAreaText.value.substring(startPosition, endPosition);
            }
        }
        if (textToSpeak === "") {
            textToSpeak = kWorkAreaTextPlaceholder;
        }

        // 1. Create a new SpeechSynthesisUtterance object
        const utterance = new SpeechSynthesisUtterance(textToSpeak);

        // Optional: Customize properties
        utterance.lang = 'en-US'; // Set the language
        utterance.pitch = 1;     // Set the pitch (0 to 2)
        utterance.rate = 1;      // Set the speaking rate (0.1 to 10)
        utterance.volume = 1;    // Set the volume (0 to 1)

        // 2. Use the window.speechSynthesis.speak() method to play the text
        window.speechSynthesis.speak(utterance);
    }
}

function Download(event) {
    event.stopPropagation();
    WorkAreaFocus();

    textData = elements.workAreaText.value;
    if (textData === "") {
        textData = kWorkAreaTextPlaceholder;
    }

    filename = "Mmojo Complete Work Area.txt"

    try {
        const blob = new Blob([textData], { type: "text/plain" });
        const blobUrl = window.URL.createObjectURL(blob);

        const anchor = document.createElement('a');
        anchor.href = blobUrl;
        anchor.download = filename;
        document.body.appendChild(anchor);
        anchor.click();
        document.body.removeChild(anchor);

        window.URL.revokeObjectURL(blobUrl);
    }
    catch (error) {
        //  console.error('Download failed:', error);
    }
}

async function downloadFileWithFetch(url, fileName) {
  try {
    // Fetch the file content as a Blob
    const response = await fetch(url);
    if (!response.ok) {
      throw new Error('Network response was not ok');
    }
    const blob = await response.blob();
    
    // Create an object URL from the Blob
    const blobUrl = window.URL.createObjectURL(blob);
    
    // Use the anchor method from Method 1
    const anchor = document.createElement('a');
    anchor.href = blobUrl;
    anchor.download = fileName;
    document.body.appendChild(anchor);
    anchor.click();
    document.body.removeChild(anchor);

    // Clean up the object URL to free up memory
    window.URL.revokeObjectURL(blobUrl);

  } catch (error) {
    console.error('Download failed:', error);
  }
}




function Print() {
    event.stopPropagation();
    WorkAreaFocus();
    window.print();
}

function EditBookmark(event) {
    event.stopPropagation();

    let logThis = false;
    if (kLogging || logThis) console.log("EditBookmark()");

    let hash = MakeHash();
    if (kLogging || logThis) console.log("hash: " + hash);

    let bookmarkLink = "bookmark.html";
    if (hash != "") {
        bookmarkLink = bookmarkLink + hash;
    }
    window.open(bookmarkLink, '_blank');

    WorkAreaFocus();
}

function GetElapsedTimeString(ms) {
    var logThis = false;

    let result = ""
    let seconds = Math.floor(ms / 1000);
    let minutes = Math.floor(seconds / 60);
    let hours = Math.floor(minutes / 60);

    seconds = seconds - (minutes * 60)
    minutes = minutes - (hours * 60);

    if (kLogging || logThis) console.log("GetElapsedTimeString(" + ms + ")");
    if (kLogging || logThis) console.log("-   hours: " + hours);
    if (kLogging || logThis) console.log("- minutes: " + minutes);
    if (kLogging || logThis) console.log("- seconds: " + seconds);

    if (hours > 0) {
        result = String(hours) + ":" + String(minutes).padStart(2, '0') + ":" + String(seconds).padStart(2, '0');
    }
    else if (minutes > 0) {
        result = String(minutes) + ":" + String(seconds).padStart(2, '0');
    }
    else {
        result = "0:" + String(seconds).padStart(2, '0');
    }

    return result;
}

function GetCodeBlock(text, indent, startLine, endLine, codeType) {
	let result = {
		"codeType": codeType,					// e.g. "javascript", or blank.
		"contents": "",							// from startLine to endLine in text.
		"filename": "",							// parsed from first line.
		"startLine": startLine,					// line code block starts on.
		"endLine": endLine						// line code block ends on.
	};
	let logThis = false;

	if (logThis) console.log("GetCodeBlock()");
	if (logThis) console.log("- indent:" + indent);
	if (logThis) console.log("- startLine:" + startLine);
	if (logThis) console.log("- endLine:" + endLine);

	let textLines = text.split(/\r?\n/);
	indent = Math.max(indent, 0);

	if (logThis) console.log("- indent:" + indent);
	if (logThis) console.log("- textLines.length:" + textLines.length);

	if ((startLine >= 0) && (startLine < textLines.length) && (endLine >= startLine) && (endLine < textLines.length)) {
		// slice(start, end) -- starts on item start, ends on item before end.
		let blockTextLines = textLines.slice(startLine, endLine + 1);
		if (indent > 0) {
			let indentSpaces = ' '.repeat(indent);
			for (let i = 0; i < blockTextLines.length; i++) {
				let line = blockTextLines[i];
				if (line.startsWith(indentSpaces)) {
					blockTextLines[i] = line.replace(indentSpaces, '');
				}
			}
		}
		result.contents = blockTextLines.join("\n");
		if (logThis) console.log("- Getting result.contents:\n");
		if (logThis) console.log("  - startLine:\n" + startLine);
		if (logThis) console.log("  - endLine:\n" + endLine);
		if (logThis) console.log("  - result.contents:\n" + result.contents);
	}

	if (codeType == "javascript") {
		result.filename = "script.js"
		const regex = "[A-Za-z0-9-_.]+\.js";
		let match = result.contents.match(regex);
		if (match !== null) {
			result.filename = match[0];
		}
	}
	else if (codeType == "html") {
		result.filename = "index.html"
		// const regex = "[A-Za-z0-9-_.]+\.html";
		const regex = /[A-Za-z0-9-_.]+\.html/;
		let match = result.contents.match(regex);
		if (logThis) console.log("  - html match: " + match);
		if (match !== null) {
			result.filename = match[0];
		}
	}
	else if (codeType == "css") {
		result.filename = "style.css"
		const regex = "[A-Za-z0-9-_.]+\.css";
		let match = result.contents.match(regex);
		if (match !== null) {
			result.filename = match[0];
		}
	}
	else if (codeType == "python") {
		result.filename = "app.py"
		const regex = "[A-Za-z0-9-_.]+\.py";
		let match = result.contents.match(regex);
		if (match !== null) {
			result.filename = match[0];
		}
	}
	else if (codeType == "powershell") {
		result.filename = "script.ps1"
		const regex = "[A-Za-z0-9-_.]+\.ps1";
		let match = result.contents.match(regex);
		if (match !== null) {
			result.filename = match[0];
		}
	}
	else if (codeType == "json") {
		result.filename = "config.json"
		const regex = "[A-Za-z0-9-_.]+\.json";
		let match = result.contents.match(regex);
		if (match !== null) {
			result.filename = match[0];
		}
	}
	else if (codeType == "yaml") {
		result.filename = "config.yaml"
		const regex = "[A-Za-z0-9-_.]+\.yaml";
		let match = result.contents.match(regex);
		if (match !== null) {
			result.filename = match[0];
		}
	}
	else {
		result.filename = "untitled.txt"
	}

	return result;
}

function GetCodeBlocksInWorkArea() {
	let result = [];
		// Each item: {
		//    "codeType": e.g. "javascript", or blank.
		//	  "contents": what's inside the code block.
		//	  "filename": proposed filename from first line, or blank.
		//    "startLine": line code block starts on.
		//    "endLine": line code block ends on.
	let logThis = false;

	if (logThis) console.log("GetMarkdownFilesInWorkArea()");

	let startMS = Date.now();
	let wat = elements.workAreaText.value;
	let watLines = wat.split(/\r?\n/);
	let markDownFileLines = [];

	const regex = /^(\s*)```([A-Za-z0-9+_]*)\s*$/
	for (let line = 0; line < watLines.length; line++) {
		let currentWatLine = watLines[line];
		let match = regex.exec(currentWatLine);
		if (match !== null) {
			let indentString = match[1];
			let indent = indentString.length;
			let codeType = match[2];
			let index = match.index;

			if (logThis && false) {
				console.log("  - matched: [" + line + "] " + currentWatLine);
				console.log("  - indent: \"" + indentString + "\"");
				console.log("  - indent: " + indent);
				console.log("  - codeType: " + codeType);
			}
			
			markDownFileLines.push({
				"line": line,
				"indent": indent,
				"codeType": codeType
			});
		}
	}

	if (logThis && true) {
		console.log("\n\nmarkDownFileLines:");
		console.log(JSON.stringify(markDownFileLines));
	}

	// markDownFileLines is an array of ``` lines.
	// While there are at least two items in markDownFileLines, consider the firat two
	// as a possible code block to save, if they match. If they don't match, remove the
	// first item and continue.

	while (markDownFileLines.length >= 2) {
		let firstItem = markDownFileLines[0];
		let secondItem = markDownFileLines[1];
		let matchingPair = true;	// assume they match, find a reason they don't.

		if (logThis && false) {
			console.log("- Considering pair:");
			console.log("  - firstItem:\n" + JSON.stringify(firstItem));
			console.log("  - secondItem:\n" + JSON.stringify(secondItem));
		}

		// secondItem needs to be a closing ```.
		if (secondItem.codeType != "") {
			if (logThis && false) console.log("  - Pair does not match: secondItem.codeType != \"\".");
			matchingPair = false;
		}

		// indents have to match.
		if (firstItem.indent != secondItem.indent) {
			if (logThis && false) console.log("  - Pair does not match: firstItem.indent != secondItem.indent.");
			matchingPair = false;
		}

		// If we have a matching pair, add it to results, remove both items.
		// If not, remove the firstItem.
		if (matchingPair) {
			if (logThis && true) {
				console.log("- Matching pair:");
				console.log("  - firstItem:\n" + JSON.stringify(firstItem));
				console.log("  - secondItem:\n" + JSON.stringify(secondItem));
			}
			markDownFileLines.shift();
			markDownFileLines.shift();

			// add something to result.
			let codeBlock = GetCodeBlock(wat, firstItem.indent, firstItem.line + 1, secondItem.line - 1, firstItem.codeType);
			result.push(codeBlock);
		}
		else {
			if (logThis && false) {
				console.log("- Non-matching pair:");
				console.log("  - firstItem:\n" + JSON.stringify(firstItem));
				console.log("  - secondItem:\n" + JSON.stringify(secondItem));
			}
			markDownFileLines.shift();
		}
	}

	let elapsedMS = Date.now() - startMS;
	if (logThis) {
		console.log("- result:\n" + JSON.stringify(result));
		console.log("- elapsedMS: " + elapsedMS);
	}
	return result;
}

function ShowHideFilesIcon() {
	let codeBlocks = GetCodeBlocksInWorkArea();
	let showIcon = (Array.isArray(codeBlocks) && (codeBlocks.length > 0));

	if (showIcon) {
		ShowElement(elements.filesIcon);
	}
	else {
		HideElement(elements.filesIcon);
	}
}

function PopulateFilesList() {
	let logThis = false;
	let codeBlocks = GetCodeBlocksInWorkArea();
	let codeBlocksCount = codeBlocks.length;
	let fileListItemCount = elements.filesList.childElementCount - 1;

	if (logThis) console.log("PopulateFilesList()");
	if (logThis) console.log("- fileListItemCount: " + fileListItemCount);
	if (logThis) console.log("- codeBlocks.length: " + codeBlocks.length);

	// Grow the files-list.
	while (fileListItemCount < codeBlocksCount) {
		if (logThis) console.log("- Adding a files-list-item.");
		let clonedItem = elements.filesListItemTemplate.cloneNode(true);
		clonedItem.id = "files-list-item-" + fileListItemCount;
		elements.filesList.appendChild(clonedItem);
		fileListItemCount = elements.filesList.childElementCount - 1;
		if (logThis) console.log("  - fileListItemCount: " + fileListItemCount);
		if (logThis) console.log("  - codeBlocksCount: " + codeBlocksCount);
	}

	// Shrink the files-list.
	while (fileListItemCount > codeBlocksCount) {
		if (logThis) console.log("- Removing the last files-list-item.");
		const lastChild = elements.filesList.lastElementChild;
		elements.filesList.removeChild(lastChild);
		fileListItemCount = elements.filesList.childElementCount - 1;
		if (logThis) console.log("  - fileListItemCount: " + fileListItemCount);
		if (logThis) console.log("  - codeBlocksCount: " + codeBlocksCount);
	}

	// Set the contents of the files-list items.
	fileListItemCount = elements.filesList.childElementCount - 1;
	codeBlocksCount = codeBlocks.length;
	
	let count = Math.min(fileListItemCount, codeBlocksCount);
	for (let i = 1; i <= count; i++) {
		let filesListItem = elements.filesList.children[i];
		let codeBlock = codeBlocks[i - 1];
		let filename = codeBlock.filename;
		let codeType = codeBlock.codeType;

		if (filename == "")	filename = "No filename specified.";
		if (codeType == "") codeType = "No type specified.";

		filesListItem.codeBlockIndex = i;
		filesListItem.codeBlock = codeBlock;
		filesListItem.children[0].innerText = filename;
		filesListItem.children[1].innerText = codeType;
		filesListItem.children[2].innerText = codeBlock.contents;
	}

	ShowFilesDirectoryName();
}

function FilesListItemClicked(event) {
	let logThis = false;
	
	if (logThis) console.log("FilesListItemClicked() - in progress.");
	if (logThis) console.log("- event:\n" + JSON.stringify(event));
	if (logThis) console.log("- event.currentTarget.classList:\n" + JSON.stringify(event.currentTarget.classList));

	if ((event !== undefined) && (event !== null)) {
        event.stopPropagation();
    }

	let filesListItem = null;
	if (event.currentTarget.classList.contains("files-list-item")) {
		filesListItem = event.currentTarget;
	}

	// for each child of elements.filesList, remove files-list-item-selected from class list
	count = elements.filesList.childElementCount - 1;
	for (let i = 1; i <= count; i++) {
		let child = elements.filesList.children[i];
		child.classList.remove("files-list-item-selected");
	}
	
	if (filesListItem !== null) {
		filesListItem.classList.add("files-list-item-selected");
		if (logThis) console.log("- codeBlockIndex: " + filesListItem.codeBlockIndex);
		if (logThis) console.log("- codeBlock:\n" + JSON.stringify(filesListItem.codeBlock));
	}

	ShowSelectedFile();
}

function FilesListItemDoubleClicked(event) {
	let logThis = false;
	
	if (logThis) console.log("FilesListItemDoubleClicked() - in progress.");
	if (logThis) console.log("- event:\n" + JSON.stringify(event));
	if (logThis) console.log("- event.currentTarget.classList:\n" + JSON.stringify(event.currentTarget.classList));

	if ((event !== undefined) && (event !== null)) {
        event.stopPropagation();
    }

	let filesListItem = null;
	if (event.currentTarget.classList.contains("files-list-item")) {
		filesListItem = event.currentTarget;
	}

	codeBlock = SelectedCodeBlock();
	if (codeBlock !== null) {
		if (logThis) console.log("- codeBlock:\n" + JSON.stringify(codeBlock));

		if (!elements.filesArea.classList.contains("hidden")) {
			ShowPanel(event, "work-area");
		}

		let wat = elements.workAreaText.value;
		let watLines = wat.split(/\r?\n/);

		selectionStart = 0;
		for (let i = 0; i < codeBlock.startLine; i++) {
			selectionStart += watLines[i].length + 1;
		}

		WorkAreaFocus();
		elements.workAreaText.setSelectionRange(selectionStart, selectionStart);
		ScrollToSelectionStart();
	}
}

function FilesListDeselect(event) {
	if ((event !== undefined) && (event !== null)) {
        event.stopPropagation();
    }

	// for each child of elements.filesList, remove files-list-item-selected from class list
	count = elements.filesList.childElementCount - 1;
	for (let i = 1; i <= count; i++) {
		let child = elements.filesList.children[i];
		child.classList.remove("files-list-item-selected");
	}

	ShowSelectedFile();
}

function SelectedCodeBlock() {
	let logThis = false;
	let result = null;
	
	if (logThis) console.log("SelectedCodeBlock() - in progress.");
	
	count = elements.filesList.childElementCount - 1;
	for (let i = 1; i <= count; i++) {
		let child = elements.filesList.children[i];
		if (child.classList.contains("files-list-item-selected")) {
			result = child.codeBlock;
		}
	}

	return result;
}

function ShowSelectedFile() {
	let logThis = false;
	
	if (logThis) console.log("ShowSelectedFile() - in progress.");

	codeBlock = SelectedCodeBlock();

	if (codeBlock !== null) {
		if (codeBlock.filename !== "") {
			elements.fileName.innerHTML = "<b>Filename:</b> " + codeBlock.filename;
		}
		else {
			elements.fileName.innerHTML = "<b>No filename specified.</b>";
		}
		elements.fileContents.value = codeBlock.contents;
		ShowElement(elements.fileCopy);
		ShowElement(elements.fileDownload);
		//	ShowElement(elements.fileSaveAs);
	}
	else {
		elements.fileName.innerHTML = "Please click a code block in the list at left.";
		elements.fileContents.value = "";
		HideElement(elements.fileCopy);
		HideElement(elements.fileDownload);
		//	HideElement(elements.fileSaveAs);
	}
}

function FileCopy(event) {
	let logThis = false;
	
	if (logThis) console.log("FileCopy() - in progress.");
	if ((event !== undefined) && (event !== null)) {
        event.stopPropagation();
    }

	codeBlock = SelectedCodeBlock();
	if (codeBlock !== null) {
		// don't need to call this async.
		navigator.clipboard.writeText(codeBlock.contents);
	}

	elements.fileContents.focus();
}

async function SaveToDirectory(codeBlock) {
	let logThis = false;
	
	if (logThis) console.log("SaveToDirectory() - in progress.");

	if (codeBlock !== null) {
		if (script.directoryHandle !== null) {
			try {
				const fileHandle = await script.directoryHandle.getFileHandle(codeBlock.filename, { create: true });			
				
				// Create a FileSystemWritableFileStream to write to.
				const writable = await fileHandle.createWritable();
				
				// Write the contents of the file to the stream.
				await writable.write(codeBlock.contents);
				
				// Close the file and write the contents to disk.
				await writable.close();
			}
			catch(err) {
				console.error('Writing the file failed: ', err);
			}
		}
	}
}

function DownloadToBrowserDownloadsDirectory(codeBlock) {
	let logThis = false;
	
	if (logThis) console.log("DownloadToBrowserDownloadsDirectory() - in progress.");

	if (codeBlock !== null) {
		//	Qwen3.5 9B generated a code sample adapted here.
		//	Cue: "Write me some javascript code to download text as a named file in the browser."
		if (logThis) console.log("- codeBlock:\n" + JSON.stringify(codeBlock));
		
		// Create a Blob object containing the text data.
		const blob = new Blob([codeBlock.contents], { type: 'text/plain' });
	
		// Create a URL for the Blob.
		const url = URL.createObjectURL(blob);
	
		// Create a link element.
		const link = document.createElement('a');
		link.style.display = 'none';
		link.href = url;
		
		let filename = codeBlock.filename;
		if ((filename === null) || (filename === "")) {
			filename = "Untitled.txt"
		}
		link.download = filename;
	
		// Append the link to the DOM.  This is necessary for Firefox.
		document.body.appendChild(link);
	
		// Programmatically click the link to trigger the download.
		link.click();

		// Remove the link from the DOM.
		document.body.removeChild(link);

		// Clean up the URL.
		URL.revokeObjectURL(url);
	}
}

function FileDownload(event) {
	let logThis = false;
	
	if (logThis) console.log("FileDownload() - in progress.");
	if ((event !== undefined) && (event !== null)) {
        event.stopPropagation();
    }

	codeBlock = SelectedCodeBlock();
	if (codeBlock !== null) {
		DownloadToBrowserDownloadsDirectory(codeBlock);
	}
	
	elements.fileContents.focus();
}

function ShowFilesDirectoryName() {
	let logThis = false;
	
	if (logThis) console.log("UpdateFilesDirectory() - in progress.");

	let directoryHTML = "<b>Directory:</b> Browser \"Downloads\" directory, unique names."
	if (script.directoryHandle !== null) {
		directoryHTML = "<b>Directory:</b> " + script.directoryHandle.name;
	}
	
	if (script.hasDirectoryPicker) {
		ShowElement(elements.filesDirectoryChoose);
	}
	else {
		directoryHTML += " Choosing a directory requires a secure context.";
		HideElement(elements.filesDirectoryChoose);
	}

	elements.filesDirectoryName.innerHTML = directoryHTML;

	let fileCount = elements.filesList.childElementCount - 1;
	if (fileCount > 0) {
		ShowElement(elements.filesDownloadAll);
	}
	else {
		HideElement(elements.filesDownloadAll);
	}
}

async function FilesDirectoryChoose(event) {
	let logThis = false;
	
	if (logThis) console.log("FilesDirectoryChoose() - in progress.");
	if ((event !== undefined) && (event !== null)) {
        event.stopPropagation();
    }

	if (script.hasDirectoryPicker) {
		try {
			// Opens the native OS directory selector
			const dirHandle = await window.showDirectoryPicker({
				mode: 'readwrite' // Use 'read' for read-only access
			});
		
			script.directoryHandle = dirHandle;
			
		}
		catch (err) {
			console.error('Directory selection failed or was canceled:', err);
		}
		
		ShowFilesDirectoryName();
	}

	elements.fileContents.focus();
}

async function FilesDownloadAll(event) {
	let logThis = false;
	
	if (logThis) console.log("FilesDownloadAll() - in progress.");
	if ((event !== undefined) && (event !== null)) {
        event.stopPropagation();
    }

	// loop over all the code blocks
	count = elements.filesList.childElementCount - 1;
	for (let i = 1; i <= count; i++) {
		let child = elements.filesList.children[i];
		let codeBlock_i = child.codeBlock;

		for (let j = i + 1; j <= count; j++) {
			let child = elements.filesList.children[j];
			let codeBlock_j = child.codeBlock;

			if ((codeBlock_i !== null) && (codeBlock_j !== null) && (codeBlock_i.filename === codeBlock_j.filename)) {
				if (logThis) console.log("- same filename: " + codeBlock_i.filename + " (" + i + ", " + j + ")");
				codeBlock_i = null;
			}
		}

		if (codeBlock_i !== null) {
			if (script.directoryHandle !== null) {
				if (logThis) console.log("- Saving: " + codeBlock_i.filename + " (" + i + ") to " + script.directoryHandle.name + ".");
				await SaveToDirectory(codeBlock_i);
			}
			else {
				if (logThis) console.log("- Downloading: " + codeBlock_i.filename + " (" + i + ") to browser \"Downloads\" directory."); 
				DownloadToBrowserDownloadsDirectory(codeBlock_i);
			}
		}
	}

	elements.fileContents.focus();
}

function StatusStartClicked() {
	WorkAreaFocus();

	if (script.replayText !== "") {
		Replay();
	}
	else {
		Complete();
	}
}

function StatusStopClicked() {
	WorkAreaFocus();

	if (IsCompleting()) {
		StopCompleting();
	}
	else if (IsReplaying()) {
		StopReplaying();
	}
}

function StatusUndoClicked() {
	WorkAreaFocus();
	UndoChange();
}

function StatusClearClicked() {
	WorkAreaFocus();
	ClearWorkArea();
}

function UpdateBookmark() {
    let logThis = false;
    if (kLogging || logThis) console.log("UpdateBookmark()");

    bookmarkTextChanged = false;

    let hash = "#";
    let label = elements.bookmarkLabel.value;

    let temperature = elements.bookmarkTemperature.value;
    let tokens = elements.bookmarkTokens.value;
    let stopWordsText = elements.bookmarkStopWords.value;
    if (!elements.bookmarkStopWordsCheckbox.checked) {
        stopWordsText = '';
    }
    let autoComplete = elements.bookmarkAutoCompleteCheckbox.checked;
    let mode = elements.bookmarkMode.value;

    if (!kModes.includes(mode)) {
        mode = kModeCueLink;
    }
    let bookmarkTypeLink = kLinkModes.includes(mode);
    let bookmarkTypeScript = kScriptModes.includes(mode);

    let cue = elements.bookmarkCueText.value
    let completed = elements.bookmarkCompletedText.value

    var data = {
        "label": label,
        "temperature": temperature,
        "tokens": tokens,
        "stop-words": stopWordsText,
        "auto-complete": autoComplete,
        "mode": mode,
        "cue": cue,
        "completed": completed,
    }

    if (kLogging || logThis) console.log(data);
    if (kLogging || logThis) console.log("----------")

    let dataJson = JSON.stringify(data);
    hash = '#' + btoa(encodeURIComponent(dataJson));

    if (kLogging || logThis) console.log(dataJson);

    if (label == '') {
        label = "Mmojo Complete"
        if (cue != '') {
            label = (append) ? "+++ Complete: " : "Complete: ";
            label = label + cue.split(' ').slice(0,10).join(' ');
            label = label.replaceAll('\n', ' ');
        }
        else if (completed != '') {
            label = 'Completed: ';
            label = label + completed.split(' ').slice(0,10).join(' ');
            label = label.replaceAll('\n', ' ');
        }
    }

    if (kLogging || logThis) console.log("- dataJson:\n" + dataJson);
    if (kLogging || logThis) console.log("- hash:\n" + hash);
    if (kLogging || logThis) console.log("- label:\n" + label);

    let bookmarkLabel = "Bookmark:";
    if (bookmarkTypeLink) {
        bookmarkLabel = "Link Bookmark:"
    }
    else if (bookmarkTypeScript) {
        bookmarkLabel = "Script Bookmark:"
    }

    elements.bookmarkLinkLabel.innerText = bookmarkLabel;
    elements.bookmarkLink.innerText = label;

    if (bookmarkTypeScript) {
        // The bookmark won't run at all on the Google new tab page in Chrome. So weird. -Brad 2025-06-04

        cue = cue.replace(/[\\"']/g, '\\$&');
        cue = cue.replace(/\n/g, '\\n');

        var js =
            "javascript:(() => { \n" + 
            "    let hash = '" + hash + "';\n" +
            "    let activeElt = document.activeElement;\n" +
            "    if (typeof isMmojoPage !== 'undefined') {\n" +
            "        location.hash = hash;\n" +
            "    }\n" +
            "    else if (activeElt) {\n" +
            "        let cue = \"" + cue + "\";\n" +
            "        let value = (" + (mode == "append") + ") ? activeElt.value + cue : cue;\n" +
            "        activeElt.value = value;\n" +
            "    }\n" + 
            "})();"

        if (kLogging || logThis) console.log(js);

        elements.bookmarkLink.href = js;
    }
    else if (bookmarkTypeLink) {
        // This will work with server behind a proxy with a path. -Brad 2026-06-06.
        const currentUrl = window.location.href; 
        const parentURL = new URL('./', currentUrl); 
        var location = parentURL.href + hash;

        elements.bookmarkLink.href = location;
    }
}

function BookmarkTextChanged() {
    bookmarkTextChanged = true;
}

function ClearBookmarkMaker() {
    let logThis = false;
    if (kLogging || logThis) console.log("ClearBookmarkMaker()");

    let label = "";
    let temperature = "";
    let tokens = "";
    let stopWords = "";
    let mode = kModeCueLink;
    let autoComplete = false;
    let cue = "";
    let completed = "";

    elements.bookmarkLabel.value = label;
    elements.bookmarkTemperature.value = temperature;
    elements.bookmarkTokens.value = tokens;
    elements.bookmarkStopWordsCheckbox.checked = (stopWords != '');
    elements.bookmarkStopWords.value = stopWords;
    elements.bookmarkMode.value = mode;
    elements.bookmarkAutoCompleteCheckbox.checked = autoComplete;

    elements.bookmarkCueText.value = cue;
    elements.bookmarkCompletedText.value = completed;

    UpdateBookmark();
}

function BookmarkOnDrop(event) {
    let logThis = false;
    if (kLogging || logThis) console.log("BookmarkOnDrop(event)");

    event.preventDefault();

    try {
        let bookmarkData = "";
        let hash = "";
        let jsonData = "";
        let data = "";
    
        if (kLogging || logThis) console.log("event.dataTransfer.types: " + event.dataTransfer.types);

        if (event.dataTransfer.types.includes("text/plain")) {
            if (kLogging || logThis) console.log("event.dataTransfer.types has text/plain.");
            bookmarkData = event.dataTransfer.getData("text/plain");
        }

        if (kLogging || logThis) console.log("bookmarkData: " + bookmarkData);

        var hostUrl = window.location.protocol + "//" + window.location.host;

        if (bookmarkData.startsWith("javascript:(") && bookmarkData.endsWith("();")) {
            if (kLogging || logThis) console.log("This is one of our script bookmarks.");

            let regex = /'.*?'/g;
            let matches = bookmarkData.match(regex);
            let match = matches[0];
            if (kLogging || logThis) console.log("match: " + match);
            hash = match.replaceAll('#', '').replaceAll('\'', '');
            if (kLogging || logThis) console.log("hash: " + hash);

            UseBookmarkHash(hash);
        }
        else if (bookmarkData.startsWith(hostUrl)) {
            if (kLogging || logThis) console.log("This is one of our link bookmarks.");

            let regex = /#.*/g;
            let matches = bookmarkData.match(regex);
            let match = matches[0];
            if (kLogging || logThis) console.log("match: " + match);
            hash = match.replaceAll('#', '').replaceAll('\'', '');
            if (kLogging || logThis) console.log("hash: " + hash);

            UseBookmarkHash(hash);
        }
    }
    catch {
        if (kLogging || logThis) console.log("settings_drop() catch");
    }

    UpdateBookmark();
}

function BookmarkOnDragOver(event) {
    let logThis = false;
    if (kLogging || logThis) console.log("BookmarkOnDragOver(event)");

	event.preventDefault();
}

function UseBookmarkHash(hash) {
    let logThis = false;
    if (kLogging || logThis) console.log("UseBookmarkHash() -- " + hash);

    let label = null;
    let temperature = null;
    let tokens = null;
    let stopWords = null;
    let mode = kModeCueLink;
    let autoComplete = false;
    let cue = "";
    let completed = "";

    // If something goes wrong, restore the settings.
    let saveLabelValue = elements.bookmarkLabel.value;
    let saveTemperatureValue = elements.bookmarkTemperature.value;
    let saveTokensValue = elements.bookmarkTokens.value;
    let saveStopWordsCheckboxValue = elements.bookmarkStopWordsCheckbox.checked;
    let saveStopWordsValue = elements.bookmarkStopWords.value;
    let saveModeValue = elements.bookmarkMode.value;
    let saveAutoCompleteValue = elements.bookmarkAutoCompleteCheckbox.checked;
    let saveCueTextValue = elements.bookmarkCueText.value;
    let saveCompletedTextValue = elements.bookmarkCompletedText.value;

    try {
        var dataJson = decodeURIComponent(atob(hash.replace('#', '')));

        if (dataJson != '') {
            if (kLogging || logThis) console.log("dataJson:");
            if (kLogging || logThis) console.log(dataJson);
            var data = JSON.parse(dataJson);
            if (kLogging || logThis) console.log("data:");
            if (kLogging || logThis) console.log(data);

            // content will be pasted in immediately.
            // completed will be pasted in by replayer.

            if ('label' in data) {
                label = data['label'];
                elements.bookmarkLabel.value = label;
            }
            else {
                elements.bookmarkLabel.value = '';
            }

            if ('temperature' in data) {
                temperature = data['temperature'];
                elements.bookmarkTemperature.value = temperature;
            }
            else {
                elements.bookmarkTemperature.value = '0.25';
            }

            if ('tokens' in data) {
                tokens = data['tokens'];;
                elements.bookmarkTokens.value = tokens;
            }
            else {
                elements.bookmarkTokens.value = '-1';
            }

            if ('stop-words' in data) {
                stopWords = data['stop-words'];
                elements.bookmarkStopWordsCheckbox.checked = (stopWords != "");
                elements.bookmarkStopWords.value = stopWords;
            }
            else {
                elements.bookmarkStopWordsCheckbox.checked = false
                elements.bookmarkStopWords.value = '';
            }

            if ('mode' in data) {
                mode = data['mode'];
                if (kLogging || logThis) console.log("mode: " + mode);
                if (!kModes.includes(mode)) {
                    mode = kModeCueLink;
                }
                if (kLogging || logThis) console.log("mode: " + mode);
                elements.bookmarkMode.value = mode;
            }
            else {
                elements.bookmarkMode.value = kModeCueLink;
            }

            if ('auto-complete' in data) {
                autoComplete = data['auto-complete'];
                elements.bookmarkAutoCompleteCheckbox.checked = autoComplete;
            }
            else {
                elements.bookmarkAutoCompleteCheckbox.checked = false;
            }

            if ('cue' in data) {
                cue = data['cue'];
                elements.bookmarkCueText.value = cue;
            }
            else {
                elements.bookmarkCueText.value = '';
            }

            if ('completed' in data) {
                completed = data['completed'];
                elements.bookmarkCompletedText.value = completed;
            }
            else {
                elements.bookmarkCompletedText.value = '';
            }

            // convert old generate to complete.
            if ('generated' in data) {
                completed = data['generated'];
                elements.bookmarkCompletedText.value = completed;
            }

            if ('auto-generate' in data) {
                autoComplete = data['auto-generate'];
                elements.bookmarkAutoCompleteCheckbox.checked = autoComplete;
            }

            // convert old append and replace to modes.
            if ('append' in data) {
                let append = data['append'];
                if (append) {
                    elements.bookmarkMode.value = kModeAppend;
                }
            }

            if ('replace' in data) {
                let replace = data['replace'];
                if (replace) {
                    elements.bookmarkMode.value = kModeReplace;
                }
            }

            if (kLogging || logThis) console.log('- cue:');
            if (kLogging || logThis) console.log(cue);
            if (kLogging || logThis) console.log('- completed:');
            if (kLogging || logThis) console.log(completed);
        }
    }
    catch {
        if (kLogging || logThis) console.log("UseHash() catch");

        elements.bookmarkLabel.value = saveLabelValue;
        elements.bookmarkTemperature.value = saveTemperatureValue;
        elements.bookmarkTokens.value = saveTokensValue;
        elements.bookmarkStopWordsCheckbox.checked = saveStopWordsCheckboxValue;
        elements.bookmarkStopWords.value = saveStopWordsValue;

        elements.bookmarkAutoCompleteCheckbox.checked = saveAutoCompleteValue;
        elements.bookmarkMode.value = saveModeValue;

        elements.bookmarkCueText.value = saveCueTextValue;
        elements.bookmarkCompletedText.value = saveCompletedTextValue;
    }

    elements.bookmarkCue.focus();
    UpdateBookmark();

    // updatingHash = true;
    // location.hash = '';
}

function UseTheme() {
	var theme = localStorage.getItem("theme");
	if ((theme === undefined) || (theme === null)) {
		theme = "peach-olive";
	}
	elements.theme.value = theme;
	
	if (theme === "light") {
		elements.body.classList.add("theme-light");
		elements.body.classList.remove("theme-dark");
	}
	else if (theme === "dark") {
		elements.body.classList.remove("theme-light");
		elements.body.classList.add("theme-dark");
	}
	else {
		elements.body.classList.remove("theme-light");
		elements.body.classList.remove("theme-dark");
	}	
}

function NextTheme() {
	var theme = localStorage.getItem("theme");
	if ((theme === undefined) || (theme === null)) {
		theme = "peach-olive";
	}

	if (theme === "peach-olive") {
		theme = "light";
	}
	else if (theme === "light") {
		theme = "dark";
	}
	else if (theme === "dark") {
		theme = "peach-olive";
	}
	else {
		theme = "peach-olive";
	}
	
	localStorage.setItem("theme", theme);
	UseTheme();
}
