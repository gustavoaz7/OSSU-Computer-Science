const DEST_MAP = new Map(
  Object.entries({
    "": "000",
    M: "001",
    D: "010",
    MD: "011",
    A: "100",
    AM: "101",
    AD: "110",
    AMD: "111",
  })
);

const COMP_MAP = new Map(
  Object.entries({
    "0": "0101010",
    "1": "0111111",
    "-1": "0111010",
    D: "0001100",
    A: "0110000",
    "!D": "0001101",
    "!A": "0110001",
    "-D": "0001111",
    "-A": "0110011",
    "D+1": "0011111",
    "A+1": "0110111",
    "D-1": "0001110",
    "A-1": "0110010",
    "D+A": "0000010",
    "D-A": "0010011",
    "A-D": "0000111",
    "D&A": "0000000",
    "D|A": "0010101",
    M: "1110000",
    "!M": "1110001",
    "-M": "1110011",
    "M+1": "1110111",
    "M-1": "1110010",
    "D+M": "1000010",
    "D-M": "1010011",
    "M-D": "1000111",
    "D&M": "1000000",
    "D|M": "1010101",
  })
);

const JUMP_MAP = new Map(
  Object.entries({
    "": "000",
    JGT: "001",
    JEQ: "010",
    JGE: "011",
    JLT: "100",
    JNE: "101",
    JLE: "110",
    JMP: "111",
  })
);

function toBinary(n) {
  const binary = n.toString(2);
  const padLeft = "0".repeat(16 - binary.length);
  return `${padLeft}${binary}`;
}

function translateInstructions(instructions, symbolTable) {
  let variableAddress = 16;
  return instructions
    .reduce((acc, instruction) => {
      switch (instruction.type) {
        case "A_NUMBER":
          return [...acc, toBinary(instruction.value)];
        case "A_SYMBOL":
          if (!symbolTable.has(instruction.value)) {
            symbolTable.set(instruction.value, variableAddress++);
          }
          return [...acc, toBinary(symbolTable.get(instruction.value))];
        case "C":
          const binary =
            "111" +
            COMP_MAP.get(instruction.comp) +
            DEST_MAP.get(instruction.dest) +
            JUMP_MAP.get(instruction.jump);
          return [...acc, binary];
        default:
          throw new Error("ERROR in instruction: ", instruction);
      }
    }, [])
    .concat([""])
    .join("\n");
}

module.exports = {
  DEST_MAP,
  COMP_MAP,
  JUMP_MAP,
  translateInstructions,
};
