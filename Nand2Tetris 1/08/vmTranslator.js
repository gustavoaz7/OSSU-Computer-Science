const fs = require("fs");
const path = require("path");
const { parse } = require("./parser");
const { translateInstructions, translateBootstrap } = require("./translator");

const TRAILING_SLASH_REGEX = /\/$/;
const SYS_INIT_REGEX = /^\s*function\s+Sys\.init\s+0\s*$/m;


function getPathsFromInput() {
  const inputPath = process.argv[2].replace(TRAILING_SLASH_REGEX, "");
  if (fs.statSync(inputPath).isDirectory()) {
    const directoryName = path.basename(inputPath);
    const asmPath = `${inputPath}/${directoryName}.asm`;
    const vmPaths = fs.readdirSync(inputPath).reduce((acc, file) => (
      path.extname(file) === '.vm' ? [...acc, `${inputPath}/${file}`] : acc
    ), []);
    return { asmPath, vmPaths };
  }
   const asmPath = inputPath.replace(/\.vm$/, ".asm");
   const vmPaths = [inputPath];
  return { asmPath, vmPaths };
}


(function main() {
  const { asmPath, vmPaths } = getPathsFromInput();
  console.log(`Translate ${vmPaths.join(", ")} into ${asmPath}\n`);

  const asmCodes = vmPaths.reduce((acc, vmPath) => {
    const filename = path.basename(vmPath, ".vm");
    const sourceCode = fs.readFileSync(vmPath, { encoding: "utf8" });
    const instructions = parse(sourceCode);
    
    const asmCode = translateInstructions(instructions, filename);
    if (SYS_INIT_REGEX.test(sourceCode)) {
      return ['// === Bootstrap ===', ...translateBootstrap(), ...acc, asmCode];
    }
    return [...acc, asmCode];
  }, []).join('\n');

  fs.writeFileSync(asmPath, asmCodes, { encoding: "utf8" });
})();
