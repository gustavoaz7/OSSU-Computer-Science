const {
  SYMBOL,
  STRING_CONST,
  KEYWORD,
  INT_CONST,
  IDENTIFIER,
  SUBROUTINE_CALL,
} = require('./constants');

const ops = new Set('+-*/&|<>='.split(''));
const unaryOps = new Set('-~'.split(''));
const subroutineDecs = new Set(['constructor', 'function', 'method']);
const classVarDecs = new Set(['static', 'field']);
const constants = new Set(['true', 'false', 'null', 'this']);

const isSymbol = (token = {}, value) =>
    token.type === SYMBOL && token.value === value;

const isOp = (token = {}) =>
    token.type === SYMBOL && ops.has(token.value);

const isUnaryOps = (token = {}) =>
    token.type === SYMBOL && unaryOps.has(token.value);

const isKeyword = (token= {}, value = undefined) =>
    token.type === KEYWORD && (value === undefined || token.value === value);

const isSubroutineDec = (token = {}) =>
    token.type === KEYWORD && subroutineDecs.has(token.value);

const isClassVarDec = (token = {}) =>
    token.type === KEYWORD && classVarDecs.has(token.value);

const isConstant = (token = {}) => (
  token.type === INT_CONST
  || token.type === STRING_CONST
  || token.type === KEYWORD
  && constants.has(token.value)
);

const isIdentifier = token => token.type === IDENTIFIER;


function parse(tokens) {
  return parseClass(tokens).node;
}

// 'class' className '{' classVarDec* subroutineDec* '}'
function parseClass(tokens) {
  const children = tokens.slice(0,3);
  let remainingTokens = tokens.slice(3);

  while (true) {
    const classVarDec = parseOptionalClassVarDec(remainingTokens);
    if (!classVarDec.node) break;

    children.push(classVarDec.node);
    remainingTokens = classVarDec.remainingTokens;
  }

  while (true) {
    const subroutineDec = parseOptionalSubroutineDec(remainingTokens);
    if (!subroutineDec.node) break;

    children.push(subroutineDec.node);
    remainingTokens = subroutineDec.remainingTokens;
  }

  children.push(remainingTokens.shift());

  return {
    node: { type: 'class', children },
    remainingTokens,
  }
}

// ('static'|'field') type varName (',' varName)* ';'
function parseOptionalClassVarDec(tokens) {
  if (!isClassVarDec(tokens[0])) {
    return { remainingTokens: tokens };
  }

  const lastIndex = tokens.findIndex(token => token.value === ';');

  return {
    node: {
      type: 'classVarDec',
      children: tokens.slice(0, lastIndex + 1), // + 1 for ';'
    },
    remainingTokens: tokens.slice(lastIndex + 1),
  };
}

// ('constructor'|'function'|'method') ('void'|type) subroutineName '(' parameterList ')' subroutineBody
function parseOptionalSubroutineDec(tokens) {
  if (!isSubroutineDec(tokens[0])) {
    return { remainingTokens: tokens };
  }

  const children = tokens.slice(0,4);
  let remainingTokens = tokens.slice(4);

  const parameterList = parseParameterList(remainingTokens);
  children.push(parameterList.node);
  remainingTokens = parameterList.remainingTokens

  children.push(remainingTokens.shift());

  const subroutineBody = parseSubroutineBody(remainingTokens);
  children.push(subroutineBody.node);
  remainingTokens =subroutineBody.remainingTokens;

  return {
    node: { type: 'subroutineDec', children },
    remainingTokens,
  }
}

// ((type varName)(',' type varName)*)?
function parseParameterList(tokens) {
  const lastIndex = tokens.findIndex(token => token.value === ')');

  return {
    node: {
      type: 'parameterList',
      children: tokens.slice(0, lastIndex),
    },
    remainingTokens: tokens.slice(lastIndex),
  };
}

// '{' varDec* statements '}'
function parseSubroutineBody(tokens) {
  const children = tokens.slice(0, 1);
  let remainingTokens = tokens.slice(1);

  while (true) {
    const varDec = parseOptionalVarDec(remainingTokens);
    if (!varDec.node) break;

    children.push(varDec.node);
    remainingTokens = varDec.remainingTokens;
  }

  const statements = parseStatements((remainingTokens));
  children.push(statements.node);
  remainingTokens = statements.remainingTokens;
  children.push(remainingTokens.shift());

  return {
    node: { type: 'subroutineBody', children },
    remainingTokens,
  };

}

// 'var' type varName (',' varName)* ';'
function parseOptionalVarDec(tokens) {
  if (!isKeyword(tokens[0], 'var')) {
    return { remainingTokens: tokens };
  }

  const lastIndex = tokens.findIndex(token => token.value === ';');

  return {
    node: {
      type: 'varDec',
      children: tokens.slice(0, lastIndex + 1), // + 1 for ';'
    },
    remainingTokens: tokens.slice(lastIndex + 1),
  };
}

// statement*
function parseStatements(tokens) {
  const children = [];
  let remainingTokens = tokens.slice();

  while (true) {
    const statement = parseOptionalStatement(remainingTokens);
    if (!statement.node) break;

    children.push(statement.node);
    remainingTokens = statement.remainingTokens;
  }

  return {
    node: { type: 'statements', children },
    remainingTokens,
  }
}

// letStatement|ifStatement|whileStatement|doStatement|returnStatement
function parseOptionalStatement(tokens) {
  if (isKeyword(tokens[0])) {
    switch (tokens[0].value) {
      case 'let':    return parseLetStatement(tokens);
      case 'if':     return parseIfStatement(tokens);
      case 'while':  return parseWhileStatement(tokens);
      case 'do':     return parseDoStatement(tokens);
      case 'return': return parseReturnStatement(tokens);
    }
  }
  return { remainingTokens: tokens };
}

// 'let' varName ('[' expression ']')? '=' expression ';'
function parseLetStatement(tokens) {
  const children = tokens.slice(0, 2);
  let remainingTokens = tokens.slice(2);

  if (isSymbol(remainingTokens[0], '[')) {
    children.push(remainingTokens.shift());

    const expression = parseExpression(remainingTokens);
    children.push(expression.node);
    remainingTokens = expression.remainingTokens;
    children.push(remainingTokens.shift());
  }

  children.push(remainingTokens.shift());

  const expression = parseExpression(remainingTokens);
  children.push(expression.node);
  remainingTokens = expression.remainingTokens;
  children.push(remainingTokens.shift());

  return {
    node: { type: 'letStatement', children },
    remainingTokens,
  };
}

// 'if' '(' expression ')' '{' statements '}'
// ('else' '{' statements '}')?
function parseIfStatement(tokens) {
  const children = tokens.slice(0, 2);
  let remainingTokens = tokens.slice(2);

  const expression = parseExpression(remainingTokens);
  children.push(expression.node);
  remainingTokens = expression.remainingTokens;

  children.push(remainingTokens.shift())
  children.push(remainingTokens.shift())

  const statements = parseStatements(remainingTokens);
  children.push(statements.node);
  remainingTokens = statements.remainingTokens;

  children.push(remainingTokens.shift());

  if (isKeyword(remainingTokens[0], 'else')) {
    children.push(remainingTokens.shift());
    children.push(remainingTokens.shift());

    const statements = parseStatements(remainingTokens);
    children.push(statements.node);
    remainingTokens = statements.remainingTokens;

    children.push(remainingTokens.shift());
  }

  return {
    node: { type: 'ifStatement', children },
    remainingTokens,
  };
}

// 'while' '(' expression ')' '{' statements '}'
function parseWhileStatement(tokens) {
  const children = tokens.slice(0, 2);
  let remainingTokens = tokens.slice(2);

  const expression = parseExpression(remainingTokens);
  children.push(expression.node);
  remainingTokens = expression.remainingTokens;

  children.push(remainingTokens.shift())
  children.push(remainingTokens.shift())

  const statements = parseStatements(remainingTokens);
  children.push(statements.node);
  remainingTokens = statements.remainingTokens;

  children.push(remainingTokens.shift());

  return {
    node: { type: 'whileStatement', children },
    remainingTokens,
  };
}

// 'do' subroutineCall ';'
function parseDoStatement(tokens) {
  const children = tokens.slice(0, 1);
  let remainingTokens = tokens.slice(1);

  const subroutineCall = parseOptionalSubroutineCall(remainingTokens);
  if (subroutineCall.node) {
    children.push(subroutineCall.node);
    remainingTokens = subroutineCall.remainingTokens;
  }

  children.push(remainingTokens.shift());

  return {
    node: { type: 'doStatement', children },
    remainingTokens,
  }
}

// pattern1                              | pattern2
// subroutineName '(' expressionList ')' | (className|varName) '.' subroutineName '(' expressionList ')'
function parseOptionalSubroutineCall(tokens) {
  const children = [];
  let remainingTokens = tokens.slice();

  const pattern1 = isIdentifier(remainingTokens[0]) && isSymbol(remainingTokens[1], '(');
  const pattern2 = isIdentifier(remainingTokens[0]) && isSymbol(remainingTokens[1], '.') &&
      isIdentifier(remainingTokens[2]) && isSymbol(remainingTokens[3], '(');

  if (!pattern1 && !pattern2) {
      return { remainingTokens };
  }

  while (!isSymbol(remainingTokens[0], '(')) {
    children.push(remainingTokens.shift());
  }

  children.push(remainingTokens.shift());

  const expressionList = parseExpressionList(remainingTokens);
  children.push(expressionList.node);
  remainingTokens = expressionList.remainingTokens;

  children.push(remainingTokens.shift());

  return {
    node: { type: SUBROUTINE_CALL, children },
    remainingTokens,
  }
}

// 'return' expression? ';'
function parseReturnStatement(tokens) {
  const children = [];
  let remainingTokens = tokens.slice();

  children.push(remainingTokens.shift());

  if (!isSymbol(remainingTokens[0], ';')) {
      const expression = parseExpression(remainingTokens);
      children.push(expression.node);
      remainingTokens = expression.remainingTokens;
  }

  children.push(remainingTokens.shift());

  return {
      node: { type: 'returnStatement', children },
      remainingTokens,
  };
}

// term (op term)*
function parseExpression(tokens) {
  const children = [];
  let remainingTokens = tokens.slice();

  const term = parseTerm(remainingTokens);
  children.push(term.node);
  remainingTokens = term.remainingTokens;

  if (isOp(remainingTokens[0])) {
      children.push(remainingTokens.shift());
      const term = parseTerm(remainingTokens);
      children.push(term.node);
      remainingTokens = term.remainingTokens;
  }

  return {
      node: { type: 'expression', children },
      remainingTokens,
  };
}

// (1) integerConstant | stringConstant | keywordConstant
// (2) | unaryOp term
// (3) | '(' expression ')'
// (4) | subroutineCall
// (5) | varName
// (6) | varName '[' expression ']'
function parseTerm(tokens) {
  const children = [];
  let remainingTokens = tokens.slice();

  if (isConstant(remainingTokens[0])) {            // (1)
      children.push(remainingTokens.shift());
  } else if (isUnaryOps(remainingTokens[0])) {      // (2)
      children.push(remainingTokens.shift());

      const term = parseTerm(remainingTokens);
      children.push(term.node);
      remainingTokens = term.remainingTokens;
  } else if (isSymbol(remainingTokens[0], '(')) {  // (3)
      children.push(remainingTokens.shift());

      const expression = parseExpression(remainingTokens);
      children.push(expression.node);
      remainingTokens = expression.remainingTokens;

      children.push(remainingTokens.shift());
  } else {
      const subroutineCall = parseOptionalSubroutineCall(remainingTokens);

      if (subroutineCall.node) {       // (4)
          children.push(subroutineCall.node);
          remainingTokens = subroutineCall.remainingTokens;
      } else {                                     // (5)
          children.push(remainingTokens.shift());

          if (isSymbol(remainingTokens[0], '[')) { // (6)
              children.push(remainingTokens.shift());

              const expression = parseExpression(remainingTokens);
              children.push(expression.node);
              remainingTokens = expression.remainingTokens;

              children.push(remainingTokens.shift());
          }
      }
  }

  return {
      node: { type: 'term', children },
      remainingTokens,
  };
}

// (expression (',' expression)*)?
function parseExpressionList(tokens) {
  const children = [];
  let remainingTokens = tokens.slice();

  while (!isSymbol(remainingTokens[0], ')')) {
      const expression = parseExpression(remainingTokens);
      children.push(expression.node);
      remainingTokens = expression.remainingTokens;

      if (isSymbol(remainingTokens[0], ',')) {
          children.push(remainingTokens.shift());
      }
  }

  return {
      node: { type: 'expressionList', children },
      remainingTokens,
  };
}

module.exports = { parse };
