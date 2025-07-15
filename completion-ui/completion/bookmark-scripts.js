// Copyright 2024-25 Brad Hutchings. 
// All Rights Reserved.
// License Inquiries: brad@BradHutchings.com.

const isMmojoBookmarkPage = true;
const kLogging = false;
const kMaxCopyPastes = 20;
const kUpdated = '[[UPDATED]]';

const kModeCue = "cue";
const kModeAppend = "append";
const kModePrepend = "prepend";
const kModeReplace = "replace";
const kModes = [kModeCue, kModeAppend, kModePrepend, kModeReplace];
const kLinkModes = [kModeCue];
const kScriptModes = [kModeAppend, kModePrepend, kModeReplace];

var elements = {};
var textChanged = true;

const generatedText_placeholder = 
    "The Bookmark Maker makes web browser bookmarks and links for automating Completion Tool.\n\n" +
    "The settings are in the olive area at top:\n" +
    "    - Label lets you set the label for the bookmark so you don't have to rename it.\n" +
    "    - Temperature, Tokens, and Stop Words work as they do in Completion Tool.\n" +
    "    - If the Auto-Generate checkbox is checked, opening the bookmark will cause the model to automatically start completing.\n" +
    "    - Append will append the cue to what's in the work area. Use to make clarifying bookmarks.\n" +
    "    - Replace will update the work area text, replacing the text in the top peach area with text in the bottom peach area. Use to make clarifying bookmarks.\n" +
    "The top peach area if for your cue.\n\n" +
    "The bottom peach area (this area) is for generated text you wish to play back. You can simulate the model responding with a known response.\n\n" +
    "A bookmark link is continually updated at the top right of the olive area. " +
        "Click the link to open it in a new tab or drag the link to the Bookmarks Bar in your web browser.\n\n" +
    "Updated: " + kUpdated;

function PageLoaded() {
    FindElements();
    elements.generatedText.placeholder = generatedText_placeholder;

    UseHash(location.hash);
    updatingHash = false;

    setInterval(() => {
        if (textChanged) {
            // console.log('Text has changed.');
            UpdateBookmark();
        }
    }, 1000);
}

function FindElements() {
    elements.body                       = document.body;
    elements.content                    = document.getElementById("content");

    elements.settings                   = document.getElementById("settings");
    elements.label                      = document.getElementById("label");
    elements.temperature                = document.getElementById("temperature");
    elements.tokens                     = document.getElementById("tokens");
    elements.stopWordsCheckbox          = document.getElementById("stop-words-checkbox");
    elements.stopWordsBreak             = document.getElementById("stop-words-break");
    elements.stopWords                  = document.getElementById("stop-words");
    elements.mode                       = document.getElementById("mode");
    elements.autoGenerateCheckbox       = document.getElementById("auto-generate-checkbox");

    elements.bookmarkLabel              = document.getElementById("bookmark-label");
    elements.bookmark                   = document.getElementById("bookmark");

    elements.cueTextArea                = document.getElementById("cue-text-area");
    elements.cueText                    = document.getElementById("cue-text");
    elements.generatedTextArea          = document.getElementById("generated-text-area");
    elements.generatedText              = document.getElementById("generated-text");

}

function UpdateBookmark() {
    let logThis = false;
    if (kLogging || logThis) console.log("UpdateBookmark()");

    textChanged = false;

    let hash = "#";
    let label = elements.label.value;

    let temperature = elements.temperature.value;
    let tokens = elements.tokens.value;
    let stopWordsText = elements.stopWords.value;
    if (!elements.stopWordsCheckbox.checked) {
        stopWordsText = '';
    }
    let autoGenerate = elements.autoGenerateCheckbox.checked;
    let mode = elements.mode.value;

    // let bookmarkTypeLink = elements.bookmarkTypeLink.checked;
    // let bookmarkTypeScript = elements.bookmarkTypeScript.checked;

    if (!kModes.includes(mode)) {
        mode = kModeCue;
    }
    let bookmarkTypeLink = kLinkModes.includes(mode);
    let bookmarkTypeScript = kScriptModes.includes(mode);

    let cue = elements.cueText.value
    let generated = elements.generatedText.value

    var data = {
        "label": label,
        "temperature": temperature,
        "tokens": tokens,
        "stop-words": stopWordsText,
        "auto-generate": autoGenerate,
        "mode": mode,
        //  "append": append,
        //  "replace": replace,
        //  "bookmark-type-link" : bookmarkTypeLink,
        //  "bookmark-type-script" : bookmarkTypeScript,
        "cue": cue,
        "generated": generated,
    }

    if (kLogging || logThis) console.log(data);
    if (kLogging || logThis) console.log("----------")

    let dataJson = JSON.stringify(data);
    hash = '#' + btoa(encodeURIComponent(dataJson));

    if (kLogging || logThis) console.log(dataJson);

    if (label == '') {
        label = "Completion Tool"
        if (cue != '') {
            label = (append) ? "+++ Complete: " : "Complete: ";
            label = label + cue.split(' ').slice(0,10).join(' ');
            label = label.replaceAll('\n', ' ');
        }
        else if (generated != '') {
            label = 'Completed: ';
            label = label + generated.split(' ').slice(0,10).join(' ');
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

    elements.bookmarkLabel.innerText = bookmarkLabel;
    elements.bookmark.innerText = label;

    if (bookmarkTypeScript) {
        // The bookmark won't run at all on the Google new tab page in Chrome. So weird. -Brad 2025-06-04

        var js =
            "javascript:(() => { \n" + 
            "    let hash = '" + hash + "';\n" +
            "    let activeElt = document.activeElement;\n" +
            "    if (typeof isMmojoPage !== 'undefined') {\n" +
            "        location.hash = hash;\n" +
            "    }\n" +
            "    else if (activeElt) {\n" +
            "        let cue = \"" + cue.replace(/[\\"']/g, '\\$&') + "\";\n" +
            "        let value = (" + (mode == "append") + ") ? activeElt.value + cue : cue;\n" +
            "        activeElt.value = value;\n" +
            "    }\n" + 
            "})();"

        if (kLogging || logThis) console.log(js);

        elements.bookmark.href = js;
    }
    else if (bookmarkTypeLink) {
        var rootUrl = window.location.protocol + "//" + window.location.host + "/completion/";
        if (kLogging || logThis) console.log(rootUrl);

        var location = rootUrl + hash;

        elements.bookmark.href = location;
    }
}

function TextChanged() {
    textChanged = true;
}

function settings_drop(event) {
    let logThis = false;
    if (kLogging || logThis) console.log("settings_drop(event)");

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

        var hostUrl = window.location.protocol + "//" + window.location.host + "/completion/";


        if (bookmarkData.startsWith("javascript:(") && bookmarkData.endsWith("();")) {
            if (kLogging || logThis) console.log("This is one of our script bookmarks.");

            let regex = /'.*?'/g;
            let matches = bookmarkData.match(regex);
            let match = matches[0];
            if (kLogging || logThis) console.log("match: " + match);
            hash = match.replaceAll('#', '').replaceAll('\'', '');
            if (kLogging || logThis) console.log("hash: " + hash);

            UseHash(hash);
        }
        else if (bookmarkData.startsWith(hostUrl)) {
            if (kLogging || logThis) console.log("This is one of our link bookmarks.");

            let regex = /#.*/g;
            let matches = bookmarkData.match(regex);
            let match = matches[0];
            if (kLogging || logThis) console.log("match: " + match);
            hash = match.replaceAll('#', '').replaceAll('\'', '');
            if (kLogging || logThis) console.log("hash: " + hash);

            UseHash(hash);
        }
    }
    catch {
        if (kLogging || logThis) console.log("settings_drop() catch");
    }

    UpdateBookmark();
}

function settings_dragover(event) {
    // if (kLogging) console.log("drag over");
    event.preventDefault();
}

function ClearBookmarkMaker() {
    let logThis = false;
    if (kLogging || logThis) console.log("ClearBookmarkMaker()");

    let label = "";
    let temperature = "";
    let tokens = "";
    let stopWords = "";
    let mode = kModeCue;
    let autoGenerate = false;
    let cue = "";
    let generated = "";

    elements.label.value = label;
    elements.temperature.value = temperature;
    elements.tokens.value = tokens;
    elements.stopWordsCheckbox.checked = (stopWords != '');
    elements.stopWords.value = stopWords;
    elements.mode.value = mode;
    elements.autoGenerateCheckbox.checked = autoGenerate;

    elements.cueText.value = cue;
    elements.generatedText.value = generated;

    UpdateBookmark();
}

updatingHash = false;

function HashChange() {
    let logThis = false;
    if (kLogging || logThis) console.log("HashChange() -- " + location.hash);
    if (kLogging || logThis) console.log("- updatingHash: " + updatingHash);

    if (!updatingHash) {
        UseHash(location.hash);
    }
    updatingHash = false;
}

function UseHash(hash) {
    let logThis = false;
    if (kLogging || logThis) console.log("UseHash() -- " + hash);

    let label = null;
    let temperature = null;
    let tokens = null;
    let stopWords = null;
    let mode = kModeCue;
    let autoGenerate = false;
    let cue = "";
    let generated = "";

    // If something goes wrong, restore the settings.
    let saveLabelValue = elements.label.value;
    let saveTemperatureValue = elements.temperature.value;
    let saveTokensValue = elements.tokens.value;
    let saveStopWordsCheckboxValue = elements.stopWordsCheckbox.checked;
    let saveStopWordsValue = elements.stopWords.value;
    let saveModeValue = elements.mode.value;
    let saveAutoGenerateValue = elements.autoGenerateCheckbox.checked;
    let saveCueTextValue = elements.cueText.value;
    let saveGeneratedTextValue = elements.generatedText.value;

    try {
        var dataJson = decodeURIComponent(atob(hash.replace('#', '')));

        if (dataJson != '') {
            if (kLogging || logThis) console.log("dataJson:");
            if (kLogging || logThis) console.log(dataJson);
            var data = JSON.parse(dataJson);
            if (kLogging || logThis) console.log("data:");
            if (kLogging || logThis) console.log(data);

            // content will be pasted in immediately.
            // generated will be pasted in by replayer.

            if ('label' in data) {
                label = data['label'];
                elements.label.value = label;
            }
            else {
                elements.label.value = '';
            }

            if ('temperature' in data) {
                temperature = data['temperature'];
                elements.temperature.value = temperature;
            }
            else {
                elements.temperature.value = '0.25';
            }

            if ('tokens' in data) {
                tokens = data['tokens'];;
                elements.tokens.value = tokens;
            }
            else {
                elements.tokens.value = '-1';
            }

            if ('stop-words' in data) {
                stopWords = data['stop-words'];
                elements.stopWordsCheckbox.checked = (stopWords != "");
                elements.stopWords.value = stopWords;
            }
            else {
                elements.stopWordsCheckbox.checked = false
                elements.stopWords.value = '';
            }

            if ('mode' in data) {
                mode = data['mode'];
                elements.mode.value = mode;
            }
            else {
                elements.mode.value = kModeCue;
            }

            if ('auto-generate' in data) {
                autoGenerate = data['auto-generate'];
                elements.autoGenerateCheckbox.checked = autoGenerate;
            }
            else {
                elements.autoGenerateCheckbox.checked = false;
            }

            if ('cue' in data) {
                cue = data['cue'];
                elements.cueText.value = cue;
            }
            else {
                elements.cueText.value = '';
            }

            if ('generated' in data) {
                generated = data['generated'];
                elements.generatedText.value = generated;
            }
            else {
                elements.generatedText.value = '';
            }

            // convert old append and replace to modes.
            if ('append' in data) {
                let append = data['append'];
                if (append) {
                    elements.mode.value = kModeAppend;
                }
            }

            if ('replace' in data) {
                let replace = data['replace'];
                if (replace) {
                    elements.mode.value = kModeReplace;
                }
            }

            if (kLogging || logThis) console.log('- cue:');
            if (kLogging || logThis) console.log(cue);
            if (kLogging || logThis) console.log('- generated:');
            if (kLogging || logThis) console.log(generated);
        }
    }
    catch {
        if (kLogging || logThis) console.log("UseHash() catch");

        elements.cueText.value = saveCueTextValue;
        elements.generatedText.value = saveGeneratedTextValue;

        elements.label.value = saveLabelValue;
        elements.temperature.value = saveTemperatureValue;
        elements.tokens.value = saveTokensValue;
        elements.stopWordsCheckbox.checked = saveStopWordsCheckboxValue;
        elements.stopWords.value = saveStopWordsValue;

        elements.autoGenerateCheckbox.checked = saveAutoGenerateValue;
        elements.mode.value = saveModeValue;

        elements.cueText.value = saveCueTextValue;
        elements.generatedText.value = saveGeneratedTextValue;
    }

    elements.cueTextArea.focus();
    UpdateBookmark();

    updatingHash = true;
    location.hash = '';
}
