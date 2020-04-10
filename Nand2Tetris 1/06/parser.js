const { DEST_MAP, COMP_MAP, JUMP_MAP } = require("./translator");

const LABEL_REGEX = /^\((.+)\)$/;
const A_INSTRUCTION_NUMBER_REGEX = /^@([0-9])+/;
const A_INSTRUCTION_SYMBOL_REGEX = /^@[^0-9]\w*/;

function cleanLine(line) {
  return line.replace(/\/\/.+/, "").trim();
}

function validateANumber(n) {
  if (n > 2 ** 15 - 1) throw new Error("@NUMBER exceeds the limit");
}

function validateCLine(line) {
  const { dest, comp, jump } = getCParts(line);

  return DEST_MAP.has(dest) && COMP_MAP.has(comp) && JUMP_MAP.has(jump);
}

function getCParts(instruction) {
  const eqIndex = instruction.indexOf("=");
  const semiIndex = instruction.indexOf(";");
  return {
    dest: eqIndex < 0 ? "" : instruction.slice(0, eqIndex),
    comp: instruction.slice(
      eqIndex + 1,
      semiIndex < 0 ? instruction.length : semiIndex
    ),
    jump: semiIndex < 0 ? "" : instruction.slice(semiIndex + 1),
  };
}

function parseLine(rawLine) {
  const line = cleanLine(rawLine);
  if (!line) return null;

  if (LABEL_REGEX.test(line)) {
    return {
      type: "L",
      value: line.slice(1, -1),
    };
  } else if (A_INSTRUCTION_NUMBER_REGEX.test(line)) {
    validateANumber(line);
    return {
      type: "A_NUMBER",
      value: Number(line.slice(1)),
    };
  } else if (A_INSTRUCTION_SYMBOL_REGEX.test(line)) {
    return {
      type: "A_SYMBOL",
      value: line.slice(1),
    };
  } else {
    validateCLine(line);
    return {
      type: "C",
      ...getCParts(line),
    };
  }
}

function parse(sourceCode, symbolTable) {
  let lines = sourceCode.split(/(\r|\n)/);
  const instructions = lines.map(parseLine);

  return instructions.reduce((acc, instruction) => {
    if (!instruction) return acc;
    switch (instruction.type) {
      case "L":
        symbolTable.set(instruction.value, acc.length);
        return acc;
      case "A_NUMBER":
      case "A_SYMBOL":
      case "C":
        return [...acc, instruction];
    }
  }, []);
}

module.exports = { parse };
