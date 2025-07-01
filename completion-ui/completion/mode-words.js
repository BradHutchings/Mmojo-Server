function GetModeWords(mode) {
    var result = {
        generate: 'generate',
        Generate: 'Generate',
        generates: 'generates',
        Generates: 'Generates',
        generated: 'generated',
        Generated: 'Generated',
        generating: 'generating',
        Generating: 'Generating',
        generatedText: 'generated text',
    };

    if (mode == 'complete') {
        result.generate = "complete";
        result.Generate = "Complete";
        result.generates = "completes";
        result.Generates = "Completes";
        result.generated = "completed";
        result.Generated = "Completed";
        result.generating = "completing";
        result.Generating = "Completing";
        result.generatedText = 'completed text';
    }
    else if (mode == 'imagine') {
        result.generate = "imagine";
        result.Generate = "Imagine";
        result.generates = "imagines";
        result.Generates = "Imagines";
        result.generated = "imagined";
        result.Generated = "Imagined";
        result.generating = "imagining";
        result.Generating = "Imagining";
        result.generatedText = 'imagined text';
    }
    else if (mode == 'brainstorm') {
        result.generate = "brainstorm";
        result.Generate = "Brainstorm";
        result.generates = "brainstorms";
        result.Generates = "Brainstorms";
        result.generated = "brainstormed";
        result.Generated = "Brainstormed";
        result.generating = "brainstorming";
        result.Generating = "Brainstorming";
        result.generatedText = 'brainstormed text';
    }
    else if (mode == 'think') {
        result.generate = "think";
        result.Generate = "Think";
        result.generates = "thinks";
        result.Generates = "Thinks";
        result.generated = "thought";
        result.Generated = "Thought";
        result.generating = "thinking";
        result.Generating = "Thinking";
        result.generatedText = 'thoughts';
    }

    return result;
}

function ReplaceModeWords(value, mode) {
    var result = value;
    var modeWords = GetModeWords(mode);

    result = result.replaceAll('generated text', modeWords.generatedText);
    result = result.replaceAll('generates', modeWords.generates);
    result = result.replaceAll('Generates', modeWords.Generates);
    result = result.replaceAll('generated', modeWords.generated);
    result = result.replaceAll('Generated', modeWords.Generated);
    result = result.replaceAll('generating', modeWords.generating);
    result = result.replaceAll('Generating', modeWords.Generating);
    result = result.replaceAll('generate', modeWords.generate);
    result = result.replaceAll('Generate', modeWords.Generate);

    return result;
}
