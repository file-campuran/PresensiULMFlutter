import translate from './translate.js';
import { readFileSync, writeFileSync } from 'fs';
import { exit } from 'process';

// NOT WORK => zh, lo, km, he, fa, de, 
var to = 'en';
const separator = '=';
const batchWSeparator = false;

(async() => {
    // translateByOne();
    translateBatch();
})()

function path(lang) {
    return `../assets/locale/${lang}.json`;
}

/**
 * Translator
 * @param {*} word 
 */
async function myTranslate(word) {
    let trans = await translate(word, to, 'http:/50.232.250.157:8080');
    if (!trans) return;

    console.log(trans.word)
    return trans.word;
}

async function asyncForEach(array, callback) {
    for (let index = 0; index < array.length; index++) {
        await callback(array[index], index, array);
    }
}

/**
 * Translate JSON String
 */
async function translateBatch() {
    let rawdata = readFileSync('lang.json');
    let language = JSON.parse(rawdata);

    let orign = language;
    language = Object.keys(language).map((key) => `${language[key]}`)

    if (process.argv[2] != null) {
        to = process.argv[2];
    }

    try {
        if (batchWSeparator) {
            /* Translate */
            let word = await myTranslate(language.join(separator));

            // Append Key transalet
            let data = word.split(separator);
            let index = 0;
            Object.keys(orign).map((key) => {
                orign[key] = data[index].trim();
                index++;
            });
        } else {
            await Promise.all(Object.keys(orign).map(async(key, item) => {
                orign[key] = await myTranslate(orign[key]);
            }));
            console.log("ORIGIN", orign);
        }

        // Read data target
        let rawdata = readFileSync(path(to));
        language = JSON.parse(rawdata);

        // Set Data Append
        orign = {
            ...language,
            ...orign,
        };
        orign = JSON.stringify(orign);

        // Write File Ttranslate
        writeFileSync(path(to), orign, null, 4);
    } catch (error) {
        console.warn('ERROR', error);
    }
}

/**
 * Translate JSON Value one by one
 */
async function translateByOne() {
    console.log('language', language);

    await Promise.all(Object.keys(language).map(async(key) => {
        language[key] = await myTranslate(language[key]);
    }));

    console.log('TRANSLATE', language);
}