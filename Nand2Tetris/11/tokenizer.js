const {
  SYMBOL,
  STRING_CONST,
  KEYWORD,
  INT_CONST,
  IDENTIFIER,
} = require('./constants');

const REGEX_INLINE_COMMENTS = /\/\/.*(\r|\n)/g;
const REGEX_MULTILINE_COMMENTS = /\/\*(.|\r|\n)*?\*\//g;
const REGEX_WHITESPACES = /\s+/g;
const REGEX_NOT_WORD = /\W/;
const STRING_QUOTE = '"';

const symbols = new Set('{}()[].,;+-*/&|<>=~'.split(''));

const keywords = new Set([
  'boolean',
  'char',
  'class',
  'constructor',
  'do',
  'else',
  'false',
  'field',
  'function',
  'if',
  'int',
  'let',
  'method',
  'null',
  'return',
  'static',
  'this',
  'true',
  'var',
  'void',
  'while',
]);


const cleanJackCode = code => code
  .replace(REGEX_INLINE_COMMENTS, '')
  .replace(REGEX_MULTILINE_COMMENTS, '')
  .replace(REGEX_WHITESPACES, ' ');

function getWord(jackCode) {
  const match = jackCode.slice(1).match(REGEX_NOT_WORD);
  if (match) {
    return jackCode.slice(0, match.index + 1);
  }
  return jackCode;
}

function getNextToken(jackCode) {
  const char = jackCode[0];

  if (symbols.has(char)) {
    return {
      token: { type: SYMBOL, value: char },
      length: 1,
    };
  }

  if (char === STRING_QUOTE) {
    const closingQuote = jackCode.indexOf(STRING_QUOTE, 1);
    return {
      token: { type: STRING_CONST, value: jackCode.slice(1, closingQuote) },
      length: closingQuote + 1,
    };
  }

  const word = getWord(jackCode);
  if (keywords.has(word)) {
    return {
      token: { type: KEYWORD, value: word },
      length: word.length,
    };
  }

  const value = parseInt(word);
  if (!isNaN(value)) {
    return {
      token: { type: INT_CONST, value },
      length: word.length,
    };
  }

  return {
    token: { type: IDENTIFIER, value: word },
    length: word.length,
  };
}

function tokenize(rawJackCode) {
  let jackCode = cleanJackCode(rawJackCode);
  const tokens = [];

  while(jackCode.length) {
    if (jackCode[0] === ' ') {
      jackCode = jackCode.slice(1);
    } else {
      const { token, length } = getNextToken(jackCode);
      tokens.push(token);
      jackCode = jackCode.slice(length);
    }
  }
  return tokens;
}

module.exports = { tokenize };
