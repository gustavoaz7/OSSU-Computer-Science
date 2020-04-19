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

function translateFunction(name, nums) {
  const push0 = ["@SP", "M=M+1", "A=M-1", "M=0"];
  return [...Array(nums).keys()].reduce((acc, _) => [...acc, ...push0], [
    `(${name})`,
  ]);
}

function translateCall(name, nums) {
  const n = labelIndex++;
  const savesReturnAddress = [`@LABEL${n}`, "D=A", ...push];
  const savesSymbols = ["LCL", "ARG", "THIS", "THAT"].reduce(
    (acc, symbol) => [...acc, `@${symbol}`, "D=M", ...push],
    []
  );
  const pointsArgSymbol = [
    "@SP",
    "D=M",
    `@${nums + 5}`,
    "D=D-A",
    "@ARG",
    "M=D",
  ];
  const pointsLclSymbol = ["@SP", "D=M", "@LCL", "M=D"];
  const jumpToCalledFn = [`@${name}`, '0;JMP'];
  const returnLabel = [`(LABEL${n})`];
  return [
    ...savesReturnAddress,
    ...savesSymbols,
    ...pointsArgSymbol,
    ...pointsLclSymbol,
    ...jumpToCalledFn,
    ...returnLabel,
  ];
}

function translateReturn() {
  // general purpose registers: index 13-15 (13 used by translatePop)
  const savesReturnAddressAtR14 = [
    "@LCL",
    "D=M",
    "@5",
    "A=D-A",
    "D=M",
    "@R14",
    "M=D",
  ];
  const savesReturnValueAtArg0 = [...pop, "@ARG", "A=M", "M=D"];
  const restoreSp = ["@ARG", "D=M+1", "@SP", "M=D"];
  const restoreThat = ["@LCL", "D=M", "@1", "A=D-A", "D=M", "@THAT", "M=D"];
  const restoreThis = ["@LCL", "D=M", "@2", "A=D-A", "D=M", "@THIS", "M=D"];
  const restoreArg = ["@LCL", "D=M", "@3", "A=D-A", "D=M", "@ARG", "M=D"];
  const restoreLcl = ["@LCL", "D=M", "@4", "A=D-A", "D=M", "@LCL", "M=D"];
  const jumpToReturnAddress = ["@R14", "A=M", "0;JMP"];
  return [
    ...savesReturnAddressAtR14,
    ...savesReturnValueAtArg0,
    ...restoreSp,
    ...restoreThat,
    ...restoreThis,
    ...restoreArg,
    ...restoreLcl,
    ...jumpToReturnAddress,
  ];
}

function translateBootstrap() {
  return ['@256', 'D=A', '@0', 'M=D', ...translateCall('Sys.init', 0)];
}

function translateInstructions(instructions, filename) {
  return instructions
    .reduce((acc, instruction) => {
      const {
        type,
        operation,
        segment,
        index,
        label,
        name,
        nums,
      } = instruction;
      switch (type) {
        case "C_ARITHMETIC":
          return [...acc, translateArithmetic(operation).join("\n")];
        case "C_PUSH":
          return [...acc, translatePush(segment, index, filename).join("\n")];
        case "C_POP":
          return [...acc, translatePop(segment, index, filename).join("\n")];
        case "C_LABEL":
          return [...acc, `(${label})`];
        case "C_GOTO":
          return [...acc, `@${label}`, "0;JMP"];
        case "C_IF_GOTO":
          return [...acc, ...pop, `@${label}`, "D;JNE"];
        case "C_FUNCTION":
          return [...acc, ...translateFunction(name, nums)];
        case "C_CALL":
          return [...acc, ...translateCall(name, nums)];
        case "C_RETURN":
          return [...acc, ...translateReturn()];
        default:
          throw new Error("Unknown instruction: ", instruction);
      }
    }, [])
    .concat([""])
    .join("\n");
}

module.exports = { translateInstructions, translateBootstrap };
