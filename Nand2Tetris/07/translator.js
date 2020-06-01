const SYMBOLS_MAP = new Map(
  Object.entries({
    local: "LCL",
    argument: "ARG",
    this: "THIS",
    that: "THAT",
  })
);

const pop = ["@SP", "M=M-1", "A=M", "D=M"];
const push = ["@SP", "M=M+1", "A=M-1", "M=D"];
const doubleComp = ["@SP", "M=M-1", "A=M", "D=M", "A=A-1", "D=M-D", "M=-1"];

let labelIndex = 0;

function translateArithmetic(operation) {
  switch (operation) {
    // Single operation
    case "neg":
      return ["@SP", "A=M-1", "M=-M"];
    case "not":
      return ["@SP", "A=M-1", "M=!M"];
    // Double operation
    case "add":
      return [...pop, "A=A-1", "M=M+D"];
    case "sub":
      return [...pop, "A=A-1", "M=M-D"];
    case "and":
      return [...pop, "A=A-1", "M=D&M"];
    case "or":
      return [...pop, "A=A-1", "M=D|M"];
    // Double comparison
    case "eq": {
      const n = labelIndex++;
      return [
        ...doubleComp,
        `@LABEL${n}`,
        "D;JEQ",
        "@SP",
        "A=M-1",
        "M=0",
        `(LABEL${n})`,
      ];
    }
    case "lt": {
      const n = labelIndex++;
      return [
        ...doubleComp,
        `@LABEL${n}`,
        "D;JLT",
        "@SP",
        "A=M-1",
        "M=0",
        `(LABEL${n})`,
      ];
    }
    case "gt": {
      const n = labelIndex++;
      return [
        ...doubleComp,
        `@LABEL${n}`,
        "D;JGT",
        "@SP",
        "A=M-1",
        "M=0",
        `(LABEL${n})`,
      ];
    }

    default:
      throw new Error("Unknown arithmetic operation: ", operation);
  }
}

function getFixedSegmentAddress(segment, index, filename) {
  switch (segment) {
    case "pointer": // index 3-4
      return `@${3 + +index}`;
    case "temp": // index 5-12
      return `@${5 + +index}`;
    case "static":
      return `@${filename}.${index}`;
    default:
      return null;
  }
}

function translatePush(segment, index, filename) {
  const fixedAddress = getFixedSegmentAddress(segment, index, filename);
  switch (segment) {
    case "constant":
      return [`@${index}`, "D=A", ...push];
    case "static":
    case "pointer":
    case "temp":
      return [fixedAddress, "D=M", ...push];
    default:
      return [
        "@" + SYMBOLS_MAP.get(segment),
        "D=M",
        `@${index}`,
        "A=D+A",
        "D=M",
        ...push,
      ];
  }
}

function translatePop(segment, index, filename) {
  const fixedAddress = getFixedSegmentAddress(segment, index, filename);
  switch (segment) {
    case "pointer":
    case "static":
    case "temp":
      return [...pop, fixedAddress, "M=D"];
    default:
      // general purpose registers: index 13-15
      return [
        `@${SYMBOLS_MAP.get(segment)}`,
        "D=M",
        `@${index}`,
        "D=D+A",
        "@R13",
        "M=D",
        ...pop,
        "@R13",
        "A=M",
        "M=D",
      ];
  }
}

function translateInstructions(instructions, filename) {
  return instructions
    .reduce((acc, instruction) => {
      const { type, operation, segment, index } = instruction;
      switch (type) {
        case "C_ARITHMETIC":
          return [...acc, translateArithmetic(operation).join("\n")];
        case "C_PUSH":
          return [...acc, translatePush(segment, index, filename).join("\n")];
        case "C_POP":
          return [...acc, translatePop(segment, index, filename).join("\n")];
        default:
          throw new Error("Unknown instruction: ", instruction);
      }
    }, [])
    .concat([""])
    .join("\n");
}

module.exports = { translateInstructions };
