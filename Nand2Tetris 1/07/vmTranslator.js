const fs = require("fs");
const path = require("path");
const { parse } = require("./parser");
const { translateInstructions } = require("./translator");

const vmPath = process.argv[2];
const asmPath = vmPath.replace(/\.vm$/, ".asm");
console.log(`Translate ${vmPath} into ${asmPath}\n`);

const sourceCode = fs.readFileSync(vmPath, { encoding: "utf8" });

(function main() {
  const filename = path.basename(vmPath, ".vm");
  const instructions = parse(sourceCode);
  const asmCode = translateInstructions(instructions, filename);
  fs.writeFileSync(asmPath, asmCode, { encoding: "utf8" });
})();
