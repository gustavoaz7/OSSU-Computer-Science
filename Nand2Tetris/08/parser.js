function cleanLine(line) {
  return line.replace(/\/\/.*/, "").trim();
}

function parseLine(rawLine) {
  const line = cleanLine(rawLine);
  if (!line) return null;

  const [commandType, arg1, arg2] = line.split(/\s+/);

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
      return { type: "C_PUSH", segment: arg1, index: arg2 };
    case "pop":
      return { type: "C_POP", segment: arg1, index: arg2 };
    case "label":
      return { type: "C_LABEL", label: arg1 };
    case "goto":
      return { type: "C_GOTO", label: arg1 };
    case "if-goto":
      return { type: "C_IF_GOTO", label: arg1 };
    case "function":
      return { type: "C_FUNCTION", name: arg1, nums: +arg2 };
    case "call":
      return { type: "C_CALL", name: arg1, nums: +arg2 };
    case "return":
      return { type: "C_RETURN" };
    default:
      throw new Error(`Unknown command type: ${commandType}`);
  }
}

function parse(sourceCode) {
  const lines = sourceCode.split(/(\r|\n)/);
  return lines.reduce((instructions, line) => {
    const instruction = parseLine(line);
    if (!instruction) return instructions;
    return [...instructions, instruction];
  }, []);
}

module.exports = { parse };
