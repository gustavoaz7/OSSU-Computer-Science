const fs = require('fs');
const path = require('path');
const { tokenize } = require('./tokenizer');
const { parse } = require('./parser');
const { tokensToXml, treeToXml } = require('./xml');

const TRAILING_SLASH_REGEX = /\/$/;

function getPathsFromInput() {
  const inputPath = process.argv[2].replace(TRAILING_SLASH_REGEX, '');
  if (fs.statSync(inputPath).isDirectory()) {
    return fs.readdirSync(inputPath).reduce((acc, file) => (
      path.extname(file) === '.jack'
        ? {
            ...acc,
            jackPaths: [...acc.jackPaths, `${inputPath}/${file}`],
            xmlPaths: [...acc.xmlPaths, `${inputPath}/${file.replace(/(.jack)$/, '.xml')}`],
            tokenXmlPaths: [...acc.tokenXmlPaths, `${inputPath}/${file.replace(/(.jack)$/, 'T.xml')}`],
          } 
        : acc
    ), { jackPaths: [], xmlPaths: [], tokenXmlPaths: [] });
  } else {
    const xmlPaths = [inputPath.replace(/\.jack$/, '.xml')];
    const tokenXmlPaths = [inputPath.replace(/\.jack$/, 'T.xml')];
     const jackPaths = [inputPath];
    return { jackPaths, xmlPaths, tokenXmlPaths };
  }
}


const { jackPaths, xmlPaths, tokenXmlPaths } = getPathsFromInput();

jackPaths.forEach((jackPath, i) => {
  const xmlPath = xmlPaths[i];
  const tokenXmlPath = tokenXmlPaths[i];
  const jackCode = fs.readFileSync(jackPath, { encoding: "utf8" });

  console.log(`Tokenizing ${jackPath} into ${tokenXmlPath}`);
  const tokens = tokenize(jackCode);
  const tokenizedXml = tokensToXml(tokens);
  fs.writeFileSync(tokenXmlPath, tokenizedXml, {encoding: 'utf8'});
  
  console.log(`Parsing ${jackPath} into ${xmlPath}\n`);
  const tree = parse(tokens);
  const parsedXml = treeToXml(tree);
  fs.writeFileSync(xmlPath, parsedXml, {encoding: 'utf8'});
});
