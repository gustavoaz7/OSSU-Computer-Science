function cleanLine(line) {
  return line.replace(/\/\/.+/, "").trim();
}

function parseLine(rawLine) {
  const line = cleanLine(rawLine);
  if (!line) return null;

  const [commandType, segment, index] = line.split(/\s+/);

  switch (commandType.toLowerCase()) {
    case "add":
      return { type: "C_ARITHMETIC", operation: "add" };
    case "sub":
      return { type: "C_ARITHMETIC", operation: "sub" };
    case "neg":
      return { type: "C_ARITHMETIC", operation: "neg" };
    case "eq":
      return { type: "C_ARITHMETIC", operation: "eq" };
    case "gt":
      return { type: "C_ARITHMETIC", operation: "gt" };
    case "lt":
      return { type: "C_ARITHMETIC", operation: "lt" };
    case "and":
      return { type: "C_ARITHMETIC", operation: "and" };
    case "or":
      return { type: "C_ARITHMETIC", operation: "or" };
    case "not":
      return { type: "C_ARITHMETIC", operation: "not" };
    case "push":
      return { type: "C_PUSH", segment, index };
    case "pop":
      return { type: "C_POP", segment, index };
    default:
      throw new Error(`Unknown command type: ${commandType}`);
  }
}

function parse(sourceCode) {
  let lines = sourceCode.split(/(\r|\n)/);
  const instructions = lines.map(parseLine).filter(Boolean);
  return instructions;
}

module.exports = { parse };
