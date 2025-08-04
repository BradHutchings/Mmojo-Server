// Copyright 2024-25 Brad Hutchings. 
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

const kMmojoCompletion = "Mmojo Completion";
const kStatus_TypeSomething = "Awaiting your cue.";
const kStatus_Ready = "Ready.";
const kStatus_Evaluating = "Evaluating.";
const kStatus_EvaluatingProgress = "Evaluating ";
const kStatus_EvaulatingFinishing = "Finishing evaluating.";
const kStatus_Completing = "Completing.";
const kStatus_FinishedCompleting = "Finished completing in [elapsed_time].";
const kStatus_StoppedByWord = "Stopped by \"[stopping_word]\".";
const kStatus_StoppedAfterCompleting = "Stopped after completing [tokens_predicted] tokens.";
const kStatus_StoppedByUser = "Stopped by you.";

const kModeCueLink = "cue-link";
const kModeCueScript = "cue-script";
const kModeAppend = "append";
const kModePrepend = "prepend";
const kModeReplace = "replace";
const kModeReplaceRegEx = "replace-regex";

var elements = {};
var controller = null;          // Rename: completingController
var completing = false;         // Replace this with a mode: kMode_Typing, kMode_Completing, kMode_Replaying
var replaying = false;
var metadata = {};
var contextWindowSize = 0;
var tokenCount = 0;
var modelName = "";

var isMobile = (navigator.maxTouchPoints > 1) && (window.navigator.userAgent.includes("Mobi"));

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

var workAreaText_placeholder = 
    "Welcome to Mmojo Completion, delivered to you from your own Mmojo Server. " +
    "Anything you do with LLMs in the cloud, you can do here, privately.\n\n" +
    "Type some text in this work area that will get the language model started. The text you type is called a \"cue\".\n\n" +
    "Once you've entered your cue, click the Start button at the bottom or type the ENTER key to start completing.\n\n" +
    "Click the ? button (top-right) for more help.";

function PageLoaded() {
    FindElements();
    SetCopyPasteScripts();
    ResizeCopyPaste();

    elements.updated.innerText = kUpdated;

    elements.workAreaText.placeholder = workAreaText_placeholder;
    elements.workAreaText.value = '';
    elements.workAreaText.focus();

    EnableControls();
    if (isMobile) {
        HideElement(elements.bookmarkIcon);
        HideElement(elements.fullScreenIcon);
    }

    SetStatusReady();
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
}

function PageResized() {
    // ShowHideModel();
}

function FindElements() {
    elements.body                   = document.body;
    elements.content                = document.getElementById("content");
    elements.printLayout            = document.getElementById("print-layout");
    elements.printPicture           = document.getElementById("print-picture");
    elements.printContent           = document.getElementById("print-content");

    elements.titleBar               = document.getElementById("title-bar");
    elements.mmojoCompletion        = document.getElementById("mmojo-completion");
    elements.settingsIcon           = document.getElementById("settings-icon");
    //  elements.hashIcon               = document.getElementById("hash-icon");
    //  elements.colorWheelIcon         = document.getElementById("color-wheel-icon");
    elements.bookmarkIcon           = document.getElementById("bookmark-icon");
    elements.helpIcon               = document.getElementById("help-icon");
    elements.fullScreenIcon         = document.getElementById("full-screen-icon");

    elements.settings               = document.getElementById("settings");
    elements.temperature            = document.getElementById("temperature");
    elements.tokens                 = document.getElementById("tokens");
    elements.stopWordsCheckbox      = document.getElementById("stop-words-checkbox");
    elements.stopWordsBreak         = document.getElementById("stop-words-break");
    elements.stopWordsLabel         = document.getElementById("stop-words-label");
    elements.stopWords              = document.getElementById("stop-words");

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

    elements.status                 = document.getElementById("status");
    elements.statusText             = document.getElementById("status-text");
    elements.statusETA              = document.getElementById("status-eta");
    elements.statusTokens           = document.getElementById("status-tokens");
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

    if ((completedContent != '') && (workAreaText.endsWith(completedContent))) {
        elements.workAreaText.value = completedContent.trimStart();
        elements.workAreaText.focus();
        completedContent = "";
        EnableCopyPaste();
        PushChange();
    }
}

function ClearWorkArea() {
    elements.workAreaText.value = '';
    elements.workAreaText.focus();

    ClearUndoRedoStack();
    ShowHideStatusButtons();
    SetStatusReady();
}

function EnableControls() {
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

    EnableCopyPaste();
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
    elements.stopWords.selectionStart = elements.stopWords.selectionEnd = elements.stopWords.value.length;
}

function Complete() {
    if (!completing && !replaying) {
        PushChange();
 
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

        if (tokenCount <= contextWindowSize) {
            SetCompleting(true);
            StartCompleting(workAreaText, temperature, tokens, stopWords);
        }
        else {
            let problemText = "\n\n----------------------------------------\n\n" +
                "The text in the work area (" + tokenCount + " tokens) exceeds the context window size (" + contextWindowSize + " tokens) for this model.\n\n" +
                "Please remove some text from the work area or switch to a bigger model.";
            elements.workAreaText.value = elements.workAreaText.value + problemText;

            ScrollToEnd();
            PushChange();
        }
    }
}

function SetCompleting(value) {
    if (completing != value) {
        completing = value;

        ShowHideStatusButtons();
        EnableCopyPaste();

        if (completing) {
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

            /*
            setTimeout(() => {
                if (!completing) {
                    SetStatusReady();
                }
            }, 5000);
            */
            PushChange();
        }
    }
}

var manualStop = false;
var completedContent = '';

async function StartCompleting(workAreaText, temperature, tokens, stopWords) {
    let logThis = false;

    // show that we're working??
    SetStatus(kStatus_Evaluating);

    var success = true;
    var data = {
        "prompt": workAreaText,
        "echo": true,
        "n_predict": tokens,
        "temperature": temperature,
        "stream": true,
        "include_prompt_progress": true,
    }

    if (stopWords.length > 0) {
        data.stop = stopWords;
    }

    var progressText = workAreaText;

    controller = new AbortController();
    manualStop = false;
    completedContent = '';

    try {
        let startMS = Date.now();
        
        const response = await fetch(kCompletionsURL, {
            method: 'POST',
            mode: 'cors',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data),
            signal: controller.signal,
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

                    if ("prompt_processing" in lineData.data) {
                        if (kLogging || logThis) console.log("Prompt processing:");
                        if (kLogging || logThis) console.log(lineData.data.prompt_processing);

                        let n_past = lineData.data.prompt_processing.n_past;
                        let n_prompt_tokens = lineData.data.prompt_processing.n_prompt_tokens;

                        let elapsedMS = Date.now() - startMS;
                        let etaMS = ((elapsedMS * n_prompt_tokens) / n_past) - elapsedMS;

                        if (kLogging || logThis) console.log("n_past: " + n_past);
                        if (kLogging || logThis) console.log("n_prompt_tokens: " + n_prompt_tokens);

                        if (n_past < n_prompt_tokens) {
                            let status = kStatus_EvaluatingProgress + " " + n_past + " / " + n_prompt_tokens;

                            HideElement(elements.statusTokens);
                            SetStatus(status, etaMS);
                        }
                        else {
                            SetStatus(kStatus_EvaulatingFinishing);
                            ShowElement(elements.statusTokens);
                        }
                    }
                    else if (lineData.data.stop) {
                        if (lineData.data.stop_type == "word") {
                            // if (kLogging) console.log("stopping_word: " + lineData.data.stopping_word);
                            SetStatus(kStatus_StoppedByWord.replace('[stopping_word]', lineData.data.stopping_word));
                            ShowElement(elements.statusTokens);
                
                            content = content + lineData.data.stopping_word;
                            completedContent = completedContent + lineData.data.stopping_word;
                            elements.workAreaText.value = content;

                            elements.workAreaText.focus();
                            ScrollToEnd();
                            
                            controller = null;
                            ShowHideStatusButtons();
                        }
                        else if (lineData.data.stop_type == "limit") {
                            let status = kStatus_StoppedAfterCompleting.replace('[tokens_predicted]', lineData.data.tokens_predicted);

                            SetStatus(status);
                            ShowElement(elements.statusTokens);
                            
                            content = content + lineData.data.content;
                            completedContent = completedContent + lineData.data.content;
                            elements.workAreaText.value = content;
                            
                            ScrollToEnd();
                            // elements.workAreaText.scrollTop = elements.workAreaText.scrollHeight
                            // don't set selectionStart, selectionEnd?

                            controller = null;
                            ShowHideStatusButtons();
                        }
                        else if (lineData.data.stop_type == "eos") {
                            let elapsedMS = Date.now() - startMS;
                            let elapsedTime = GetElapsedTimeString(elapsedMS);
                            let status = kStatus_FinishedCompleting.replace('[elapsed_time]', elapsedTime);
                            if (kLogging || logThis) console.log("Completed:" + status);

                            SetStatus(status);
                            ShowElement(elements.statusTokens);

                            content = content + lineData.data.content;
                            completedContent = completedContent + lineData.data.content;
                            elements.workAreaText.value = content;

                            ScrollToEnd();
                            // elements.workAreaText.scrollTop = elements.workAreaText.scrollHeight
                            // don't set selectionStart, selectionEnd?

                            if (kLogging || logThis) console.log("end of stream");
                            controller = null;
                            ShowHideStatusButtons();
                        }
                    }

                    else if (lineData.data.content !== undefined) {
                        SetStatus(kStatus_Completing);
                        ShowElement(elements.statusTokens);

                        content = content + lineData.data.content;
                        completedContent = completedContent + lineData.data.content;
                        elements.workAreaText.value = content;

                        ScrollToEnd();
                        // elements.workAreaText.scrollTop = elements.workAreaText.scrollHeight
                        // don't set selectionStart, selectionEnd?
                    }

                }
            }
        }
    }
    catch(exc) {
        if (kLogging || logThis) console.log("Exception caught receiving results.");
        if (kLogging || logThis) console.log(exc.name);
        if (kLogging || logThis) console.log(exc.message);

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
                ScrollToEnd();
            }
        }
    }

    controller = null;
    SetCompleting(false);
}

function StopCompleting() {
    if (controller !== null) {
        controller.abort();
        controller = null;
        manualStop = true;

        ShowHideStatusButtons();
        ShowElement(elements.statusTokens);
        SetStatus(kStatus_StoppedByUser);
        SetCompleting(false);

        elements.workAreaText.focus();
        ScrollToEnd();
    }
}

function Replay(completed) {
    if (!replaying && !completing) {
        PushChange();

        SetReplaying(true);
        SetStatus("Replaying...");
 
        var workAreaText = elements.workAreaText.value;
        var words = completed.split(' ');
        var i = 0;

        function type() {
            if (replaying && (i < words.length)) {
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
                completedContent = completed;
            }
        }
        
        type();
    }
}

function SetReplaying(value) {
    if (replaying != value) {
        replaying = value;

        ShowHideStatusButtons();

        if (replaying) {
            //  elements.statusStop.focus();
        
            elements.workAreaText.style.backgroundColor = "var(--grey-lightlight)";
            // elements.workAreaText.style.borderColor = "var(--color6)";
            elements.workAreaText.focus();
        }
        else {
            elements.workAreaText.style.backgroundColor = "var(--color2)";
            // elements.workAreaText.style.borderColor = "var(--color2)";
            elements.workAreaText.focus();

            SetStatusReady();
            PushChange();
        }
    }
}

function StopReplaying() {
    SetReplaying(false);
}

function WorkAreaTextPaste() {
    if (!completing && !replaying) {
        // Force this to happen after the paste. If you double paste
        // too quickly, it will get caught in the same change.
        setTimeout(() => {
            PushChange();
        }, 500);
    }
    else {
        event.preventDefault(); // Prevent the default paste behavior
    }

    SetStatusReady();
    ShowHideStatusButtons();
}

function ShowHideStatusButtons() {
    if ((elements.workAreaText.value != '') && !completing) {
        ShowElement(elements.statusStart);
    }
    else {
        HideElement(elements.statusStart);
    }

    if (completing) {
        ShowElement(elements.statusStop);
    }
    else {
        HideElement(elements.statusStop);
    }

    if ((isMobile || true) && (undoStack.length > 0) && !completing) {
        ShowElement(elements.statusUndo);
    }
    else {
        HideElement(elements.statusUndo);
    }

    if ((isMobile || true) && (elements.workAreaText.value != '') && !completing) {
        ShowElement(elements.statusClear);
    }
    else {
        HideElement(elements.statusClear);
    }
}

function SetStatus(status, etaMS = 0) {
    let showETA = false;
    let eta = "";

    if (etaMS > 0) {
        let etaMinutes = Math.round((etaMS / 1000) / 60);

        if (etaMinutes == 1) {
            eta = "1 minute."
            showETA = true;
        }
        else if (etaMinutes > 1) {
            eta = "" + etaMinutes + " minutes."
            showETA = true;
        }
    }

    elements.statusText.innerHTML = "<b>Status:</b>&nbsp;" + status;
    elements.statusETA.innerHTML = "<b>ETA:</b>&nbsp;" + eta;

    if (showETA) {
        ShowElement(elements.statusETA);
    }
    else {
        HideElement(elements.statusETA);
    }
}

function SetStatusReady() {
    var w = elements.content.offsetWidth;
    SetStatus((w >= 400) ? kStatus_TypeSomething : kStatus_Ready);
}


var completionStartedMS = 0;
const completionMinimumTimeMS = 1500;

function WorkAreaTextKeyDown(event) {
    let logThis = false;
    if (kLogging || logThis) console.log('WorkAreaTextKeyDown()');
    
    // if we're completing, return true
    if (completing) {
        if (kLogging || logThis) console.log('- completing');
        event.preventDefault();

        // return key in the field should stop completing.
        if (event.keyCode == 13) {
            if ((Date.now() - completionStartedMS) >= completionMinimumTimeMS) {
                if (kLogging || logThis) console.log('- return');
                StopCompleting();
            }
        }
    }

    else if (replaying) {
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
            elements.workAreaText.selectionStart = elements.workAreaText.selectionEnd = elements.workAreaText.value.length;
        }
        event.preventDefault();

        completionStartedMS = Date.now();
        setTimeout(() => {
            Complete();
        }, 500);
    }

    else {
        // This will change the content area, so forget completedContent.
        completedContent = "";
        SetStatusReady();
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

function ToggleFullScreen() {
    var elt = document.documentElement;

    if (document.fullscreenElement) {
        if (kLogging) ('Exit fullscreen.');
        document.exitFullscreen();
    }
    else {
        if (kLogging) ('Enter fullscreen.');
        document.documentElement.requestFullscreen();
    }

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
            completedContent:   completedContent,
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
            completedContent                        = item.completedContent;
        }
        else {
            elements.workAreaText.value = "";
            elements.workAreaText.selectionStart = 0;
            elements.workAreaText.selectionEnd = 0;
            completedContent = "";
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
        completedContent                        = item.completedContent;

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
        // signal: controller.signal,
    });

    const json = await response.json();

    try {
        if (kLogging) console.log("json:\n");
        if (kLogging) console.log(json);

        const data0 = json.data[0];
        metadata = data0.meta;
        modelName = metadata["general.name"];
        const n_ctx_train = metadata["n_ctx_train"];
        const n_ctx = metadata["n_ctx"];

        if (kLogging) console.log("json.data[0]:\n");
        if (kLogging) console.log(data0);

        if (kLogging) console.log("json.data[0].meta:\n");
        if (kLogging) console.log(metadata);

        if (kLogging) console.log("meta[\"general.name\"]:\n");
        if (kLogging) console.log(modelName);

        if (kLogging) console.log("meta[\"n_ctx_train\"]:\n");
        if (kLogging) console.log(n_ctx_train);

        contextWindowSize = n_ctx;
        elements.model.innerHTML = modelName;
    }
    catch(exc) {
        if (kLogging) console.log("Exception caught receiving results from " + kModelsURL + ".");
        if (kLogging) console.log(exc);

        modelName = "";
        elements.model.innerHTML = '';
    }
}

function ToggleSettings() {
    ToggleShowElement(elements.settings);
    HideElement(elements.printSettings);
}

function TogglePrintSettings() {
    ToggleShowElement(elements.printSettings)
    HideElement(elements.settings);
}

function ScrollToEnd() {
    if (elements.workAreaText.value != '') {
        elements.workAreaText.scrollTop = elements.workAreaText.scrollHeight;
    }
    else {
        elements.workAreaText.scrollTop = 0;
    }
    elements.workAreaText.selectionStart = elements.workAreaText.selectionEnd = elements.workAreaText.value.length;

}

function MakeHash() {
    let logThis = false;
    if (kLogging || logThis) console.log("MakeHash(" + completed + ")");
    if (kLogging || logThis) console.trace();

    let result = '';

    if (completedContent === undefined) {
        completedContent = '';
    }

    var workAreaText = elements.workAreaText.value;
    var cue = '';
    var completed = '';

    if ((completedContent != '') && (workAreaText.endsWith(completedContent))) {
        cue = workAreaText.substring(0, workAreaText.length - completedContent.length);
        completed = completedContent;
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

    var label = 'Completion Tool';
    if (cue != '') {
        label = (completed != '') ? "completed: " : "Complete: ";
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
 
    if (controller !== null) {
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
            elements.workAreaText.value = elements.workAreaText.value + cue;
            PushChange();
        }
        else if (mode == kModePrepend) {
            elements.workAreaText.value = cue + elements.workAreaText.value;
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

var lastCountTokens_workAreaText = "";
var lastCountTokens_contextWindowSize = contextWindowSize;

async function CountTokens() {
    if (kLogging) console.log("CountTokens()");

    var success = true;
    var workAreaText = elements.workAreaText.value;
    var tokensHTML = "";

    if ((lastCountTokens_workAreaText != workAreaText) || (lastCountTokens_contextWindowSize != contextWindowSize)) {
        lastCountTokens_workAreaText = workAreaText;
        lastCountTokens_contextWindowSize = contextWindowSize;

        if (kLogging) console.log("POST: " + kTokenizeURL);

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
                // signal: controller.signal,
            });
        
            const json = await response.json();

            if (kLogging) console.log("json:\n");
            if (kLogging) console.log(json);

            const tokens = json.tokens;
            if (kLogging) console.log("tokens:\n");
            if (kLogging) console.log(tokens);

            if (Array.isArray(tokens)) {
                tokenCount = tokens.length;

                if (kLogging) console.log("tokens is an array with " + tokenCount + " items.");

                if (contextWindowSize > 1 ) {
                    tokensHTML = "<b>Tokens:</b> " + tokenCount + "&nbsp;/&nbsp;" + contextWindowSize;
                }
                else {
                    tokensHTML = "<b>Tokens:</b> " + tokenCount;
                }
            }    
        }
        catch(exc) {
            if (kLogging) console.log("Exception caught receiving results from " + kTokenizeURL + ".");
            if (kLogging) console.log(exc.name);
            if (kLogging) console.log(exc.message);

            // As far as the user sees, a silent fail here is OK.
        }

        elements.statusTokens.innerHTML = tokensHTML;
        ShowHideStatusButtons();
    }

    setTimeout(function() {
        CountTokens();
    }, 2000);
}

function UpdatePicture() {

}

function EditBookmark() {
    let logThis = false;
    if (kLogging || logThis) console.log("EditBookmark()");

    let hash = MakeHash();
    if (kLogging || logThis) console.log("hash: " + hash);

    let bookmarkLink = "bookmark.html";
    if (hash != "") {
        bookmarkLink = bookmarkLink + hash;
    }
    window.open(bookmarkLink, '_blank');
}

function Chat() {
    window.open('/chat', '_blank');
}

function Print() {
    window.print();
}

function Help() {
    window.open('help.html', '_blank');
}

var mmojoCompletionClicked = false;
function ClickMmojoCompletion() {
    if (!mmojoCompletionClicked) {
        mmojoCompletionClicked = true;
        elements.mmojoCompletion.innerText = modelName;
        setTimeout(function() {
            RestoreMmojoCompletion();
        }, 3000);
    }
}

function RestoreMmojoCompletion() {
    elements.mmojoCompletion.innerText = kMmojoCompletion;
    mmojoCompletionClicked = false;
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
