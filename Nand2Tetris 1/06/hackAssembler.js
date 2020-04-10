const fs = require("fs");
const { generateSymbolTable } = require("./generateSymbolTable");
const { parse } = require("./parser");
const { translateInstructions } = require("./translator");

const asmPath = process.argv[2];
const hackPath = asmPath.replace(/\.asm$/, ".hack");
console.log(`Assemble ${asmPath} into ${hackPath}\n`);

const sourceCode = fs.readFileSync(asmPath, { encoding: "utf8" });

(function main() {
  const symbolTable = generateSymbolTable();
  const instructions = parse(sourceCode, symbolTable);
  const machineCode = translateInstructions(instructions, symbolTable);
  fs.writeFileSync(hackPath, machineCode, { encoding: "utf8" });
})();
