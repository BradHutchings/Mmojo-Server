// From: https://css-tricks.com/converting-color-spaces-in-javascript/

function RGBToHex(r,g,b) {
    r = r.toString(16);
    g = g.toString(16);
    b = b.toString(16);

    if (r.length == 1) {
        r = "0" + r;
    }
    if (g.length == 1) {
        g = "0" + g;
    }
    if (b.length == 1) {
        b = "0" + b;
    }

    return "#" + r + g + b;
}

function HexToRGB(h) {
    let r = 0, g = 0, b = 0;
  
    // 3 digits
    if (h.length == 4) {
      r = "0x" + h[1] + h[1];
      g = "0x" + h[2] + h[2];
      b = "0x" + h[3] + h[3];
  
    // 6 digits
    } else if (h.length == 7) {
      r = "0x" + h[1] + h[2];
      g = "0x" + h[3] + h[4];
      b = "0x" + h[5] + h[6];
    }
    
    return "rgb("+ +r + "," + +g + "," + +b + ")";
}


function RGBToHSL(r, g, b) {
    // Make r, g, and b fractions of 1
    r /= 255;
    g /= 255;
    b /= 255;

    // Find greatest and smallest channel values
    let cmin = Math.min(r,g,b),
    cmax = Math.max(r,g,b),
    delta = cmax - cmin,
    h = 0,
    s = 0,
    l = 0;

    // Calculate hue
    // No difference
    if (delta == 0)
        h = 0;
    // Red is max
    else if (cmax == r)
        h = ((g - b) / delta) % 6;
    // Green is max
    else if (cmax == g)
        h = (b - r) / delta + 2;
    // Blue is max
    else
        h = (r - g) / delta + 4;

    h = Math.round(h * 60);

    // Make negative hues positive behind 360°
    if (h < 0)
        h += 360;

    // Calculate lightness
    l = (cmax + cmin) / 2;

    // Calculate saturation
    s = delta == 0 ? 0 : delta / (1 - Math.abs(2 * l - 1));

    // Multiply l and s by 100
    s = +(s * 100).toFixed(1);
    l = +(l * 100).toFixed(1);

    return "hsl(" + h + "," + s + "%," + l + "%)";
}

function HSLToRGB(h,s,l) {
    // Must be fractions of 1
    s /= 100;
    l /= 100;

    let c = (1 - Math.abs(2 * l - 1)) * s,
    x = c * (1 - Math.abs((h / 60) % 2 - 1)),
    m = l - c/2,
    r = 0,
    g = 0,
    b = 0;

    if (0 <= h && h < 60) {
        r = c; g = x; b = 0;  
    }
    else if (60 <= h && h < 120) {
        r = x; g = c; b = 0;
    }
    else if (120 <= h && h < 180) {
        r = 0; g = c; b = x;
    }
    else if (180 <= h && h < 240) {
        r = 0; g = x; b = c;
    }
    else if (240 <= h && h < 300) {
        r = x; g = 0; b = c;
    }
    else if (300 <= h && h < 360) {
        r = c; g = 0; b = x;
    }

    r = Math.round((r + m) * 255);
    g = Math.round((g + m) * 255);
    b = Math.round((b + m) * 255);

    return "rgb(" + r + "," + g + "," + b + ")";
}


function rotateRGB(hex, degrees) {
    // console.log('rotateRGB(' + hex + ', ' + degrees + ')');

    let rgb = HexToRGB(hex);
    // console.log('- rgb: ' + rgb);

    rgb = rgb.replace('rgb(', '').replace(')', '');
    // console.log('- rgb: ' + rgb);

    let r = 0, g = 0, b = 0;
    let rgbSplit = rgb.split(',');
    r = rgbSplit[0];
    g = rgbSplit[1];
    b = rgbSplit[2];

    // console.log('- r: ' + r +', g: ' + g + ', b: ' + b);

    let hsl = RGBToHSL(r, g, b);
    // console.log('- hsl: ' + hsl);

    hsl = hsl.replace('hsl(', '').replace(')', '').replace('%', '').replace('%', '');
    // console.log('- hsl: ' + hsl);

    let h = 0, s = 0.0, l = 0.0;
    let hslSplit = hsl.split(',');
    h = hslSplit[0];
    s = hslSplit[1];
    l = hslSplit[2];

    // console.log('- h: ' + h +', s: ' + s + ', l: ' + l);

    // console.log('- Adding ' + degrees + ' degrees.');
    h = (parseInt(h) + degrees) % 360;
    // console.log('- h: ' + h +', s: ' + s + ', l: ' + l);

    rgb = HSLToRGB(h, s, l);
    // console.log('- rgb: ' + rgb);

    rgb = rgb.replace('rgb(', '').replace(')', '');
    // console.log('- rgb: ' + rgb);

    rgbSplit = rgb.split(',');
    r = parseInt(rgbSplit[0]);
    g = parseInt(rgbSplit[1]);
    b = parseInt(rgbSplit[2]);

    // console.log('- r: ' + r +', g: ' + g + ', b: ' + b);

    hex = RGBToHex(r, g, b).toUpperCase();
    // console.log('- hex: ' + hex);

    return hex;
}