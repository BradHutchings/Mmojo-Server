// Copyright 2024-26 Brad Hutchings. 
// All Rights Reserved.
// License Inquiries: brad@BradHutchings.com.

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
    preparing:                          1,      // page loading, not ready for editing.
    editing:                            2,      // work area is being edited.
    evaluating:                         3,      // start of evaulating.
    evaluating_progress:                4,      // evaluating has sent progress.
    evaluating_finishing:               5,      // finishing with prompt - last batch?.
    completing:                         6,      // generating new tokens.
    completed:                          7,      // show completion time in status prior to any editing.
    stopped_by_word:                    8,
    stopped_after:                      9,
    stopped_by_user:                    10,
    replaying:                          11,
    error:                              12,
});

const kStatusText = Object.freeze({
    preparing:              "Preparing.",
    editing_typeSomething:  "Awaiting your cue.",
    editing_ready:          "Ready.",
    evaluating:             "Evaluating.",
    evaluating_progress:    "Evaluating ",
    evaluating_finishing:   "Finishing evaluating.",
    completing:             "Completing.",
    completed:              "Completed in [elapsed_time].",
    stopped_by_word:        "Stopped by \"[word]\".",
    stopped_after:          "Stopped after [tokens_predicted] tokens.",
    stopped_by_user:        "Stopped by you.",
    replaying:              "Replaying.",
    error:                  "Error.",
});

const kModeCueLink = "cue-link";
const kModeCueScript = "cue-script";
const kModeAppend = "append";
const kModePrepend = "prepend";
const kModeReplace = "replace";
const kModeReplaceRegEx = "replace-regex";

const kWorkAreaTextPlaceholder = 
    "Welcome to Mmojo Complete, delivered to you from your own Mmojo Server. " +
    "Anything you do with LLMs in the cloud, you can do here, privately.\n\n" +
    "Type some text in this work area that will get the language model started. The text you type is called a \"cue\".\n\n" +
    "Once you've entered your cue, click the Start button at the bottom or type the ENTER key to start completing.\n\n" +
    "Remember: You are intelligent. LLMs do not think. Chat is an illusion.\n\n" +
    "Click the ? button (top-right) for more help.";

const kCompletionMinimumTimeMS = 1500;


var elements = {};                  // Fine to have this in global space.

var script = {};
script.completingController = null;
script.completing = false;          // Replace this with a mode: kMode_Typing, kMode_Completing, kMode_Replaying
script.replaying = false;
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
script.mmojoCompleteClicked = false;         //  This is that header showing Mmojo Complete (should be a contant kAppName) or the model name.
script.statusMode = kStatusMode.editing;
script.statusMessage = "";

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
    elements.workAreaText.focus();

    EnableControls();
    if (script.isMobile) {
        HideElement(elements.bookmarkIcon);
        HideElement(elements.fullScreenIcon);
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

    
    checked = localStorage.getItem('showCopyAndPaste');
    if (checked === "true") {
        elements.showCopyAndPasteCheckbox.checked = true;
    }
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
    elements.helpIcon                   = document.getElementById("help-icon");

    elements.toolsArea                  = document.getElementById("tools-area");
    elements.tools                      = document.getElementById("tools");
    elements.chatIcon                   = document.getElementById("chat-icon");
    elements.downloadIcon               = document.getElementById("download-icon");
    elements.printIcon                  = document.getElementById("print-icon");
    elements.bookmarkIcon               = document.getElementById("bookmark-icon");
    //  elements.colorWheelIcon             = document.getElementById("color-wheel-icon");
    elements.fullScreenIcon             = document.getElementById("full-screen-icon");

    elements.settings                   = document.getElementById("settings");
    elements.showCopyAndPasteCheckbox   = document.getElementById("show-copy-and-paste-checkbox");
    elements.temperature                = document.getElementById("temperature");
    elements.tokens                     = document.getElementById("tokens");
    elements.stopWordsCheckbox          = document.getElementById("stop-words-checkbox");
    elements.stopWordsBreak             = document.getElementById("stop-words-break");
    elements.stopWordsLabel             = document.getElementById("stop-words-label");
    elements.stopWords                  = document.getElementById("stop-words");

    elements.printSettings          = document.getElementById("print-settings");
    elements.printSize              = document.getElementById("print-size");
    elements.pictureWidth           = document.getElementById("picture-width");
    elements.pictureUrlBreak        = document.getElementById("picture-url-break");
    elements.pictureUrl             = document.getElementById("picture-url");
    elements.print                  = document.getElementById("print");

    elements.model                  = document.getElementById("model");
    elements.updated                = document.getElementById("updated");

    elements.workArea               = document.getElementById("work-area");
    elements.workAreaText           = document.getElementById("work-area-text");

    elements.copyPaste              = document.getElementById("copy-paste");    
    elements.copyPasteItem          = document.getElementById("copy-paste-item");
    elements.copyPasteSpace         = document.getElementById("copy-paste-space");
    elements.clearCue               = document.getElementById("clear-cue");
    elements.preview                = document.getElementById("preview");

	elements.filesArea				= document.getElementById("files-area");
	elements.filesList				= document.getElementById("files-list");
	elements.fileView				= document.getElementById("file-view");
	elements.fileName				= document.getElementById("file-name");
	elements.fileContents			= document.getElementById("file-contents");
	elements.fileControls			= document.getElementById("file-controls");
	elements.fileDownload			= document.getElementById("file-download");
	elements.fileSaveAs				= document.getElementById("file-save-as");

    elements.status                 = document.getElementById("status");
    elements.statusText             = document.getElementById("status-text");
    elements.statusStart            = document.getElementById("status-start");
    elements.statusStop             = document.getElementById("status-stop");
    elements.statusUndo             = document.getElementById("status-undo");
    elements.statusClear            = document.getElementById("status-clear");

    elements.gutter                 = document.getElementById("gutter");
    elements.link                   = document.getElementById("link");
    elements.copyright              = document.getElementById("copyright");

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
    elements.workAreaText.focus();

    if (copyPasteItem.pasteValue !== undefined) {
        if (kLogging) console.log("Pasting.");
        HandleCopyPasteMouseLeave(copyPasteItem);

        elements.workAreaText.value = copyPasteItem.pasteValue.workAreaText;
        elements.workAreaText.focus();
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
    elements.workAreaText.focus();

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
        elements.workAreaText.focus();
        script.completedContent = "";
        EnableCopyPaste();
        PushChange();
    }
}

function ClearWorkArea() {
    elements.workAreaText.value = '';
    elements.workAreaText.focus();

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
        console.log("Set showCopyAndPaste true.");
    }
    else {
        localStorage.setItem('showCopyAndPaste', 'false');
        console.log("Set showCopyAndPaste false.");
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

function StopWordsSetFocus() {
    elements.stopWords.focus();
    let stopWordsLength = elements.stopWords.value.length;
    elements.stopWords.setSelectionRange(stopWordsLength, stopWordsLength);
}

function Complete() {
    if (!script.completing && !script.replaying) {
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
    if (script.completing != value) {
        script.completing = value;

        ShowHideStatusButtons();
        EnableCopyPaste();

        if (script.completing) {
            //  elements.statusStop.focus();
        
            elements.workAreaText.readOnly = true;
            elements.workAreaText.caretColor = "transparent";
            elements.workAreaText.style.backgroundColor = "var(--grey-lightlight)";
            // elements.workAreaText.style.borderColor = "var(--color6)";
            elements.workAreaText.focus();
        }
        else {
            elements.workAreaText.readOnly = false;
            elements.workAreaText.caretColor = null;
            elements.workAreaText.style.backgroundColor = "var(--color2)";
            // elements.workAreaText.style.borderColor = "var(--color2)";
            elements.workAreaText.focus();

            PushChange();
        }
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

                            elements.workAreaText.focus();
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

        ShowHideStatusButtons();
        script.statusMode = kStatusMode.stopped_by_user;
        SetCompleting(false);

        elements.workAreaText.focus();
        ScrollToEnd();
    }
}

function Replay(completed) {
    if (!script.replaying && !script.completing) {
        PushChange();

        SetReplaying(true);
        script.statusMode = kStatusMode.replaying;
 
        var workAreaText = elements.workAreaText.value;
        var words = completed.split(' ');
        var i = 0;

        function type() {
            if (script.replaying && (i < words.length)) {
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
                elements.workAreaText.value = workAreaText + completed;
                ScrollToEnd();

                SetReplaying(false);
                script.completedContent = completed;
            }
        }
        
        type();
    }
}

function SetReplaying(value) {
    if (script.replaying != value) {
        script.replaying = value;

        ShowHideStatusButtons();

        if (script.replaying) {
            //  elements.statusStop.focus();
        
            elements.workAreaText.style.backgroundColor = "var(--grey-lightlight)";
            // elements.workAreaText.style.borderColor = "var(--color6)";
            elements.workAreaText.focus();
        }
        else {
            elements.workAreaText.style.backgroundColor = "var(--color2)";
            // elements.workAreaText.style.borderColor = "var(--color2)";
            elements.workAreaText.focus();

            script.statusMode = kStatusMode.editing;
            PushChange();
        }
    }
}

function StopReplaying() {
    SetReplaying(false);
}

function WorkAreaTextPaste() {
    if (!script.completing && !script.replaying) {
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
    if ((elements.workAreaText.value != '') && !script.completing && !script.replaying) {
        ShowElement(elements.statusStart);
    }
    else {
        HideElement(elements.statusStart);
    }

    if (script.completing || script.replaying) {
        ShowElement(elements.statusStop);
    }
    else {
        HideElement(elements.statusStop);
    }

    if ((script.isMobile || true) && (elements.workAreaText.value != '') && (undoStack.length > 0) && !script.completing && !script.replaying) {
        ShowElement(elements.statusUndo);
    }
    else {
        HideElement(elements.statusUndo);
    }

    if ((script.isMobile || true) && (elements.workAreaText.value != '') && !script.completing && !script.replaying) {
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
        var w = elements.content.offsetWidth;
        if (w >= 400) {
            status += kStatusText.editing_typeSomething;
            if (script.contextWindowSize > 0) {
                status += " <b>Tokens:</b> " + script.tokenCount + " / " + script.contextWindowSize + ".";
            }
            else if (script.tokenCount > 0) {
                status += " <b>Tokens:</b> " + script.tokenCount + ".";
            }
        }
        else {
            status += kStatusText.editing_ready;
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
    if (script.completing) {
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

    else if (script.replaying) {
        if (kLogging || logThis) console.log('- replaying');
        event.preventDefault();

        // return key in the field should stop replaying.
        if (event.keyCode == 13) {
            if (kLogging || logThis) console.log('- return');
            StopReplaying();
        }
    }

    // if we're not completing or replaying, and we get a return key, kick off completing.
    else if ((event.keyCode == 13) && !event.shiftKey) {
        if (kLogging || logThis) console.log("Enter key was pressed.");

        if (event.ctrlKey) {
            elements.workAreaText.value = elements.workAreaText.value + '\n';
            let workAreaLength = elements.workAreaText.value.length;
            elements.workAreaText.setSelectionRange(workAreaLength, workAreaLength);
        }
        event.preventDefault();

        setTimeout(() => {
            Complete();
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

    else {
        // This will change the content area, so forget completedContent.
        script.completedContent = "";
        script.statusMode = kStatusMode.editing;
        EnableCopyPaste();
    }

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

function ToggleFullScreen(event) {
    event.stopPropagation();

    var elt = document.documentElement;

    if (document.fullscreenElement) {
        if (kLogging) ('Exit fullscreen.');
        document.exitFullscreen();
    }
    else {
        if (kLogging) ('Enter fullscreen.');
        document.documentElement.requestFullscreen();
    }

    elements.workAreaText.focus();
}

function FullscreenChange() {
    if (document.fullscreenElement) {
        elements.fullScreenIcon.src = "images/restore-64.png";
    }
    else {
        elements.fullScreenIcon.src = "images/fullscreen-64.png";
    }
}

function KeyPress(event) {
    var evtobj = window.event? event : e

    if (event.ctrlKey && !event.shiftKey && (event.key == 'z')) {
        if (kLogging) console.log('ctrl-b');
        event.preventDefault();

        UndoChange();
    }

    if (event.ctrlKey && event.shiftKey && (event.key == 'Z')) {
        if (kLogging) console.log('ctrl-shift-b');
        event.preventDefault();

        RedoChange();
    }
}

undoStack = new Array();
redoStack = new Array();

function PushChange() {
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
        if (kLogging) console.log("Pushing change.");
        if (kLogging) console.log(elements.workAreaText.value.length);
        item = {
            workAreaText:       elements.workAreaText.value,
            selectionStart:     elements.workAreaText.selectionStart,
            selectionEnd:       elements.workAreaText.selectionEnd,
            completedContent:   script.completedContent,
        }
        undoStack.push(item);
        redoStack.length = 0;
        if (kLogging) LogUndoRedoStacks();
    }

    EnableCopyPaste();
}

function UndoChange() {
    // text has changed since last command. Create an item and push it onto redoSack.
    if (undoStack.length > 0) {
        if (kLogging) console.log("Undoing change.");
        item = undoStack.at(-1);   // top of stack

        if (elements.workAreaText.value != item.workAreaText) {
            if (kLogging) console.log("Pushing most recent change.");
            PushChange();
            item = undoStack.pop();
            redoStack.push(item);
        }

        if (kLogging) console.log("Popping item from undoStack, pushing to redoStack.");
        item = undoStack.pop();
        redoStack.push(item);

        if (kLogging) console.log("Setting workAreaText to top of undoStack.");
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
    if (redoStack.length > 0) {
        if (kLogging) console.log("Redoing change.");

        if (kLogging) console.log("Popping item from redoStack, pushing to undoStack.");
        item = redoStack.pop();
        undoStack.push(item);

        if (kLogging) console.log("Setting workAreaText to top of undoStack.");
        elements.workAreaText.value             = item.workAreaText;
        elements.workAreaText.selectionStart    = item.selectionStart;
        elements.workAreaText.selectionEnd      = item.selectionEnd;
        script.completedContent                 = item.completedContent;

        if (kLogging) console.log(elements.workAreaText.value.length);
        if (kLogging) LogUndoRedoStacks();
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

function ToggleFiles(event) {
    event.stopPropagation();
	if (elements.filesArea.classList.contains("hidden")) {
    	HideElement(elements.workArea);
    	HideElement(elements.status);
    	ShowElement(elements.filesArea);
	}
	else {
    	HideElement(elements.filesArea);
    	ShowElement(elements.workArea);
    	ShowElement(elements.status);
	}

	HideElement(elements.settings);
    HideElement(elements.toolsArea);
    HideElement(elements.printSettings);
}

function ToggleSettings(event) {
    event.stopPropagation();
	if (!elements.filesArea.classList.contains("hidden")) {
		ToggleFiles(event);
	}
	
    elements.workAreaText.focus()
    ToggleShowElement(elements.settings);
    HideElement(elements.toolsArea);
    HideElement(elements.printSettings);

    if (elements.settings.classList.contains("hidden")) {
        elements.workAreaText.focus()
    }
    else {
        elements.showCopyAndPasteCheckbox.focus()
    }
}

function ToggleTools(event) {
    event.stopPropagation();
	if (!elements.filesArea.classList.contains("hidden")) {
		ToggleFiles(event);
	}

	elements.workAreaText.focus()
    ToggleShowElement(elements.toolsArea);
    HideElement(elements.settings);
    HideElement(elements.printSettings);
}

function TogglePrintSettings() {
    elements.workAreaText.focus()
	if (!elements.filesArea.classList.contains("hidden")) {
		ToggleFiles(event);
	}

	ToggleShowElement(elements.printSettings)
    HideElement(elements.settings);
    HideElement(elements.toolsArea);
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

function MakeHash() {
    let logThis = false;
    if (kLogging || logThis) console.log("MakeHash(" + completed + ")");
    if (kLogging || logThis) console.trace();

    let result = '';

    if (script.completedContent === undefined) {
        script.completedContent = '';
    }

    var workAreaText = elements.workAreaText.value;
    var cue = '';
    var completed = '';

    if ((script.completedContent != '') && (workAreaText.endsWith(script.completedContent))) {
        cue = workAreaText.substring(0, workAreaText.length - script.completedContent.length);
        completed = script.completedContent;
    }
    else {
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
    let autoComplete = true;

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
    if (kLogging || logThis) console.log("dataJson: " + dataJson);

    var hash = "";
    try {
        hash = '#' + btoa(encodeURIComponent(dataJson));
    }
    catch {
        hash = "";
    }
    if (kLogging || logThis) console.log("hash: " + hash);

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
    elements.workAreaText.focus();
    ScrollToEnd();
    
    if ((completed == '') && (elements.workAreaText.value != '') && autoComplete) {
        setTimeout(() => {
            Complete();
        }, kWaitToComplete);
    }
    else if ((completed != null) && (completed != '')) {
        setTimeout(() => {
            Replay(completed);
        }, kWaitToComplete);
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
    elements.workAreaText.focus();

    window.open('/chat', '_blank');
}

function Read(event) {
    event.stopPropagation();
    elements.workAreaText.focus();

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
    elements.workAreaText.focus();

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
    elements.workAreaText.focus();
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

    elements.workAreaText.focus();
}

function Help(event) {
    event.stopPropagation();
    elements.workAreaText.focus();
    window.open('help.html', '_blank');
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
		"codeType": codeType,	   // e.g. "javascript", or blank.
		"contents": "",    		   // from startLine to endLine in text.
		"filename": ""	   		   // parsed from first line.
	};
	let logThis = true;

	if (logThis) console.log("GetCodeBlock() - in progress.");
	if (logThis) console.log("- indent:" + indent);
	if (logThis) console.log("- startLine:" + startLine);
	if (logThis) console.log("- endLine:" + endLine);

	let textLines = text.split(/\r?\n/);
	indent = Math.max(indent, 0);
	indent = 0;

	if (logThis) console.log("- indent:" + indent);
	if (logThis) console.log("- textLines.length:" + textLines.length);

	if ((startLine >= 0) && (startLine < textLines.length) && (endLine > startLine) && (endLine < textLines.length)) {
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
		const regex = "[A-Za-z0-9-_.]+\.js]";
		let match = result.contents.match(regex);
		if (match !== null) {
			result.filename = match[0];
		}
	}
	else if (codeType == "html") {
		const regex = "[A-Za-z0-9-_.]+\.html]";
		let match = result.contents.match(regex);
		if (match !== null) {
			result.filename = match[0];
		}
	}
	else if (codeType == "css") {
		const regex = "[A-Za-z0-9-_.]+\.css]";
		let match = result.contents.match(regex);
		if (match !== null) {
			result.filename = match[0];
		}
	}
	else if (codeType == "python") {
		const regex = "[A-Za-z0-9-_.]+\.py]";
		let match = result.contents.match(regex);
		if (match !== null) {
			result.filename = match[0];
		}
	}
	else if (codeType == "powershell") {
		const regex = "[A-Za-z0-9-_.]+\.ps1]";
		let match = result.contents.match(regex);
		if (match !== null) {
			result.filename = match[0];
		}
	}

	return result;
}

function GetCodeBlocksInWorkArea() {
	let result = [];
		// Each item: {
		//    "codeType": e.g. "javascript", or blank.
		//	  "contents": what's inside the code block.
		//	  "filename": proposed filename from first line, or blank.
	let logThis = true;

	if (logThis) console.log("GetMarkdownFilesInWorkArea() - in progress.");

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

function FileCopy() {
	console.log("FileCopy() - to be implemented.");
}

function FileDownload() {
	console.log("FileDownload() - to be implemented.");
}

function FileSaveAs() {
	console.log("FileSaveAs() - to be implemented.");
}


