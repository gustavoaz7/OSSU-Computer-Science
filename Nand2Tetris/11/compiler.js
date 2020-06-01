const { tokenize } = require("./tokenizer");
const { parse } = require("./parser");
const { SymbolTable } = require("./symbolTable");
const {
  SYMBOL,
  STRING_CONST,
  INT_CONST,
  KEYWORD,
  IDENTIFIER,
  SUBROUTINE_CALL,
} = require('./constants');

const SEGMENTS_MAP = new Map(
  Object.entries({
    static: "static",
    field: "this",
    argument: "argument",
    var: "local",
  })
);

function compile(jackCode) {
  const tokens = tokenize(jackCode);
  const tree = parse(tokens);
  return `${compileClass(tree).join("\n")}\n`;
}

// 'class' className '{' classVarDec* subroutineDec* '}'
function compileClass({ children }) {
  const symbolTable = new SymbolTable();
  return children.reduce((acc, child) => {
    switch (child.type) {
      case "identifier":
        symbolTable.className = child.value;
        return acc;
      case "classVarDec":
        processVarDec(child, symbolTable);
        return acc;
      case "subroutineDec":
        return [...acc, ...compileSubroutineDec(child, symbolTable)];
    }
    return acc;
  }, []);
}

// ('constructor'|'function'|'method') ('void'|type) subroutineName '(' parameterList ')' subroutineBody
function compileSubroutineDec({ children }, symbolTable) {
  const type = children[0].value;
  const name = children[2].value;

  symbolTable.startSubroutine(type);

  processParameterList(children[4], symbolTable);

  const subroutineBodyLines = compileSubroutineBody(children[6], symbolTable);

  const fieldsCount = symbolTable.count("field");
  const varsCount = symbolTable.count("var");

  switch (type) {
    case "constructor":
      return [
        `function ${symbolTable.className}.${name} ${varsCount}`,
        `push constant ${fieldsCount}`,
        "call Memory.alloc 1",
        "pop pointer 0",
        ...subroutineBodyLines,
      ];

    case "method":
      return [
        `function ${symbolTable.className}.${name} ${varsCount}`,
        "push argument 0",
        "pop pointer 0",
        ...subroutineBodyLines,
      ];

    case "function":
      return [
        `function ${symbolTable.className}.${name} ${varsCount}`,
        ...subroutineBodyLines,
      ];
  }
}

// '{' varDec* statements '}'
function compileSubroutineBody({ children }, symbolTable) {
  return children.reduce((acc, child) => {
    switch (child.type) {
      case "varDec":
        processVarDec(child, symbolTable);
        return acc;
      case "statements":
        return [...acc, ...compileStatements(child, symbolTable)];
    }
    return acc;
  }, []);
}

// statement*
function compileStatements({ children }, symbolTable) {
  return children.reduce((acc, child) => {
    switch (child.type) {
      case "letStatement":
        return [...acc, ...compileLetStatement(child, symbolTable)];
      case "ifStatement":
        return [...acc, ...compileIfStatement(child, symbolTable)];
      case "whileStatement":
        return [...acc, ...compileWhileStatement(child, symbolTable)];
      case "doStatement":
        return [...acc, ...compileDoStatement(child, symbolTable)];
      case "returnStatement":
        return [...acc, ...compileReturnStatement(child, symbolTable)];
    }
    return acc;
  }, []);
}

// 'let' varName ('[' expression ']')? '=' expression ';'
function compileLetStatement({ children }, symbolTable) {
  return [
    ...compileExpression(children[children.length - 2], symbolTable),
    ...move('pop', children, 1, symbolTable),
  ];
}

// 'while' '(' expression ')' '{' statements '}'
function compileWhileStatement({ children }, symbolTable) {
  const labelIndex = symbolTable.nextLabelIndex++;
  const startLabel = `WHILE_START_${labelIndex}`;
  const endLabel = `WHILE_END_${labelIndex}`;

  return [
    `label ${startLabel}`,
    ...compileExpression(children[2], symbolTable),
    "not",
    `if-goto ${endLabel}`,
    ...compileStatements(children[5], symbolTable),
    `goto ${startLabel}`,
    `label ${endLabel}`,
  ];
}

// 'if' '(' expression ')' '{' statements '}'
// ('else' '{' statements '}')?
function compileIfStatement({ children }, symbolTable) {
  const labelIndex = symbolTable.nextLabelIndex++;
  const endLabel = `IF_END_${labelIndex}`;

  const conditionLines = compileExpression(children[2], symbolTable);
  const ifLines = compileStatements(children[5], symbolTable);

  if (children.length < 8) { // Only if
    return [
      ...conditionLines,
      "not",
      `if-goto ${endLabel}`,
      ...ifLines,
      `label ${endLabel}`,
    ];
  }

  // if-else
  const trueLabel = `IF_TRUE_${labelIndex}`;
  const elseLines = compileStatements(children[9], symbolTable);
  return [
    ...conditionLines,
    `if-goto ${trueLabel}`,
    ...elseLines,
    `goto ${endLabel}`,
    `label ${trueLabel}`,
    ...ifLines,
    `label ${endLabel}`,
  ];
}

// 'do' subroutineCall ';'
function compileDoStatement({ children }, symbolTable) {
  return [...compileSubroutineCall(children[1], symbolTable), "pop temp 0"];
}

// 'return' expression? ';'
function compileReturnStatement({ children }, symbolTable) {
  return children[1].type === "expression"
    ? [...compileExpression(children[1], symbolTable), "return"]
    : ["push constant 0", "return"];
}

// pattern1                              | pattern2
// subroutineName '(' expressionList ')' | (className|varName) '.' subroutineName '(' expressionList ')'
function compileSubroutineCall({ children }, symbolTable) {
  if (children[1].value === "(") {
    const name = children[0].value;
    const expressionList = children[2];
    const argsCount = Math.floor((expressionList.children.length + 1) / 2);
    return [
      "push pointer 0",
      ...compileExpressionList(expressionList, symbolTable),
      `call ${symbolTable.className}.${name} ${argsCount + 1}`,
    ];
  }

  const classOrVarName = children[0];
  const name = children[2].value;
  const expressionList = children[4];
  const argsCount = Math.floor((expressionList.children.length + 1) / 2);

  if (symbolTable.has(classOrVarName.value)) { // Call on another instance
    const className = symbolTable.get(classOrVarName.value).type;
    return [
      ...move('push', children, 0, symbolTable),
      ...compileExpressionList(expressionList, symbolTable),
      `call ${className}.${name} ${argsCount + 1}`,
    ];
  }

  // Static call
  return [
    ...compileExpressionList(expressionList, symbolTable),
    `call ${children[0].value}.${name} ${argsCount}`,
  ];
}

// (expression (',' expression)*)?
function compileExpressionList({ children }, symbolTable) {
  return children.reduce((acc, child) => {
    if (child.type === "expression") {
      return [...acc, ...compileExpression(child, symbolTable)];
    }
    return acc;
  }, []);
}

// term (op term)*
function compileExpression({ children }, symbolTable) {
  const compiledTerm = compileTerm(children[0], symbolTable);
  if (children.length > 1) {
    return [
      ...compiledTerm,
      ...compileTerm(children[2], symbolTable),
      ...compileOp(children[1]),
    ];
  }
  return compiledTerm;
}

// (1) integerConstant | stringConstant | keywordConstant
// (2) | unaryOp term
// (3) | '(' expression ')'
// (4) | subroutineCall
// (5) | varName
// (6) | varName '[' expression ']'
function compileTerm({ children }, symbolTable) {
  switch (children[0].type) {
    case INT_CONST:
      return [`push constant ${children[0].value}`];
    case STRING_CONST:
      return compileStringConstant(children[0]);
    case KEYWORD:
      return compileKeywordConstant(children[0]);
    case IDENTIFIER:
      return move('push', children, 0, symbolTable);
    case SUBROUTINE_CALL:
      return compileSubroutineCall(children[0], symbolTable);
    case SYMBOL:
      if (children[0].value === "(") {
        return compileExpression(children[1], symbolTable);
      }
      return [
        ...compileTerm(children[1], symbolTable),
        ...compileUnaryOp(children[0]),
      ];
  }
}

function compileStringConstant({ value }) {
  const compiledLines = [`push constant ${value.length}`, 'call String.new 1'];
  for (let i = 0; i < value.length; i++) {
    compiledLines.push(
      `push constant ${value.charCodeAt(i)}`,
      'call String.appendChar 2',
    );
  }
  return compiledLines;
}

function compileKeywordConstant({ value }) {
  switch (value) {
    case "true":
      return ["push constant 0", "not"];
    case "null":
    case "false":
      return ["push constant 0"];
    case "this":
      return ["push pointer 0"];
  }
}

function compileOp({ value }) {
  switch (value) {
    case "+":
      return ["add"];
    case "-":
      return ["sub"];
    case "*":
      return ["call Math.multiply 2"];
    case "/":
      return ["call Math.divide 2"];
    case "&":
      return ["and"];
    case "|":
      return ["or"];
    case "<":
      return ["lt"];
    case ">":
      return ["gt"];
    case "=":
      return ["eq"];
  }
}

function compileUnaryOp({ value }) {
  switch (value) {
    case "-":
      return ["neg"];
    case "~":
      return ["not"];
  }
}

function move(action, nodes, start, symbolTable) {
  const varName = nodes[start].value;
  const { kind, index } = symbolTable.get(varName);

  if (
    nodes[start + 1] &&
    nodes[start + 1].type === SYMBOL &&
    nodes[start + 1].value === "["
  ) {
    const offsetExpression = nodes[start + 2];
    return [
      `push ${SEGMENTS_MAP.get(kind)} ${index}`,
      ...compileExpression(offsetExpression, symbolTable),
      "add",
      "pop pointer 1",
      `${action} that 0`,
    ];
  }

  return [`${action} ${SEGMENTS_MAP.get(kind)} ${index}`];
}

function processVarDec({ children }, symbolTable) {
  const props = { kind: children[0].value, type: children[1].value };

  for (let i = 2; i < children.length; i += 2) {
    const varName = children[i].value;
    symbolTable.set(varName, props);
  }
}

function processParameterList({ children }, symbolTable) {
  for (let i = 0; i < children.length; i += 3) {
    const type = children[i].value;
    const varName = children[i + 1].value;
    symbolTable.set(varName, { kind: "argument", type });
  }
}

module.exports = { compile };
