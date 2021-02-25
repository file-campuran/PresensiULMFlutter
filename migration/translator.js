const translate = require('./translate.js')
const fs = require('fs');

// NOT WORK => zh, lo, km, he, fa, de, 
const to = 'zh';

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
    let trans = await translate(word, to);
    if (!trans) return;
    return trans.word;
}

/**
 * Translate JSON String
 */
async function translateBatch() {
    let rawdata = fs.readFileSync(path('id'));
    let language = JSON.parse(rawdata);

    let orign = language;
    language = Object.keys(language).map((key) => `[${language[key]}]`)

    try {
        let word = await myTranslate(JSON.stringify(language));
        console.log('WORD', word)
        word = word.replace(/，/g, ',');

        switch (to) {
            case 'ar':
                word = word.replace(/،/g, ',');
                break;

            case 'de':
                word = word.replace(/ ]] "/g, '');
                break;

            case 'zh':
                word = word.replace(/“/g, '"');
                word = word.replace(/”/g, '"');
                word = word.replace(/""/g, '"');
                // word = word.replace(/,"/g, '",');
                word = word.replace(/\n/g, '"');
                word = word.replace(/\t/g, '"');
                word = word.replace(/\r/g, '"');
                break;

            case 'ja':
                word = word.replace(/、/g, ',');
                word = word.replace(/「/g, '');
                word = word.replace(/」/g, '');
                break;

            case 'ru':
                word = word.replace(/«/g, '');
                word = word.replace(/»/g, '');
                break;

            default:
                break;
        }

        console.log('REPLACE', word);

        let data = JSON.parse(word);
        let index = 0;
        Object.keys(orign).map((key) => {
            data[index] = data[index].replace('[', '');
            data[index] = data[index].replace(']', '');
            orign[key] = data[index];
            index++;
        });

        orign = JSON.stringify(orign);
        fs.writeFileSync(path(to), orign);

        console.log('PARSE', orign)
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